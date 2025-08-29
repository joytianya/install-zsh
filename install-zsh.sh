#!/bin/bash

# Zsh一键安装配置脚本
# 适用于Ubuntu/Debian/CentOS/RHEL系统

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否为root用户
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "请不要以root用户运行此脚本"
        exit 1
    fi
}

# 检测操作系统
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    else
        log_error "无法检测操作系统"
        exit 1
    fi
    
    log_info "检测到操作系统: $OS $VERSION"
}

# 安装zsh
install_zsh() {
    log_info "开始安装zsh..."
    
    case $OS in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y zsh curl git
            ;;
        centos|rhel|fedora)
            if command -v dnf &> /dev/null; then
                sudo dnf install -y zsh curl git
            else
                sudo yum install -y zsh curl git
            fi
            ;;
        *)
            log_error "不支持的操作系统: $OS"
            exit 1
            ;;
    esac
    
    log_success "zsh安装完成"
}

# 检查zsh是否在/etc/shells中
check_shells() {
    local zsh_path=$(which zsh)
    if ! grep -q "$zsh_path" /etc/shells; then
        log_info "将zsh添加到/etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi
}

# 安装Oh My Zsh
install_oh_my_zsh() {
    log_info "安装Oh My Zsh..."
    
    # 如果已存在，先备份
    if [[ -d ~/.oh-my-zsh ]]; then
        log_warning "检测到现有Oh My Zsh安装，正在备份..."
        mv ~/.oh-my-zsh ~/.oh-my-zsh.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # 安装Oh My Zsh (非交互式)
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
    log_success "Oh My Zsh安装完成"
}

# 安装常用插件
install_plugins() {
    log_info "安装常用插件..."
    
    # 自动建议插件
    if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # 语法高亮插件
    if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
    
    log_success "插件安装完成"
}

# 配置.zshrc
configure_zshrc() {
    log_info "配置.zshrc文件..."
    
    # 备份现有配置
    if [[ -f ~/.zshrc ]]; then
        cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    cat > ~/.zshrc << 'EOF'
# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# 主题设置
ZSH_THEME="agnoster"

# 插件配置
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    history-substring-search
    colored-man-pages
    command-not-found
)

source $ZSH/oh-my-zsh.sh

# 用户配置
export LANG=en_US.UTF-8
export EDITOR='vim'

# 别名
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# 历史记录配置
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# 自动纠错
setopt CORRECT
setopt CORRECT_ALL

# 自动补全配置
autoload -U compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# SSH连接优化
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
fi

# 自定义函数
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 如果存在本地配置文件，则加载
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
EOF
    
    log_success ".zshrc配置完成"
}

# 切换默认shell
change_shell() {
    log_info "切换默认shell到zsh..."
    
    local current_shell=$(echo $SHELL)
    local zsh_path=$(which zsh)
    
    if [[ "$current_shell" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        log_success "默认shell已切换到zsh"
        log_warning "需要重新登录才能生效"
    else
        log_info "当前shell已经是zsh"
    fi
}

# 创建卸载脚本
create_uninstall_script() {
    cat > ~/uninstall-zsh.sh << 'EOF'
#!/bin/bash

echo "开始卸载zsh配置..."

# 切换回bash
chsh -s /bin/bash

# 备份并删除配置文件
if [[ -f ~/.zshrc ]]; then
    mv ~/.zshrc ~/.zshrc.uninstall.backup
fi

# 删除Oh My Zsh
if [[ -d ~/.oh-my-zsh ]]; then
    rm -rf ~/.oh-my-zsh
fi

echo "zsh配置已卸载，请重新登录生效"
EOF
    
    chmod +x ~/uninstall-zsh.sh
    log_info "卸载脚本已创建: ~/uninstall-zsh.sh"
}

# 显示完成信息
show_completion() {
    echo
    echo "========================================"
    log_success "Zsh安装配置完成！"
    echo "========================================"
    echo
    echo "配置详情："
    echo "- 主题: agnoster"
    echo "- 插件: git, zsh-autosuggestions, zsh-syntax-highlighting"
    echo "- 配置文件: ~/.zshrc"
    echo "- 卸载脚本: ~/uninstall-zsh.sh"
    echo
    log_warning "请执行以下命令之一使配置生效："
    echo "1. 重新登录系统"
    echo "2. 执行: exec zsh"
    echo "3. 执行: source ~/.zshrc"
    echo
}

# 主函数
main() {
    echo "========================================"
    echo "        Zsh 一键安装配置脚本"
    echo "========================================"
    echo
    
    check_root
    detect_os
    
    # 询问是否继续
    read -p "是否继续安装zsh? (y/N): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "安装已取消"
        exit 0
    fi
    
    install_zsh
    check_shells
    install_oh_my_zsh
    install_plugins
    configure_zshrc
    change_shell
    create_uninstall_script
    show_completion
}

# 错误处理
trap 'log_error "脚本执行出错，请检查错误信息"; exit 1' ERR

# 执行主函数
main "$@"