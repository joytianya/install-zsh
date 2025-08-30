#!/bin/bash

# Zsh卸载脚本
# 移除zsh配置并恢复bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

echo "========================================"
echo "        Zsh 配置卸载脚本"
echo "========================================"
echo

# 确认卸载
read -p "确定要卸载zsh配置吗? (y/N): " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "卸载已取消"
    exit 0
fi

# 1. 切换回bash
log_info "切换默认shell回bash..."
if command -v bash &> /dev/null; then
    chsh -s $(which bash)
    log_success "默认shell已切换回bash"
else
    log_error "未找到bash，请手动设置默认shell"
fi

# 2. 备份并移除zshrc
if [[ -f ~/.zshrc ]]; then
    log_info "备份.zshrc配置文件..."
    mv ~/.zshrc ~/.zshrc.uninstall.backup.$(date +%Y%m%d_%H%M%S)
    log_success ".zshrc已备份并移除"
else
    log_info ".zshrc文件不存在，跳过"
fi

# 3. 移除Oh My Zsh
if [[ -d ~/.oh-my-zsh ]]; then
    log_info "移除Oh My Zsh..."
    rm -rf ~/.oh-my-zsh
    log_success "Oh My Zsh已移除"
else
    log_info "Oh My Zsh目录不存在，跳过"
fi

# 4. 移除本地配置
if [[ -f ~/.zshrc.local ]]; then
    log_info "备份本地配置文件..."
    mv ~/.zshrc.local ~/.zshrc.local.uninstall.backup.$(date +%Y%m%d_%H%M%S)
    log_success ".zshrc.local已备份并移除"
fi

# 5. 清理可能的历史文件
if [[ -f ~/.zsh_history ]]; then
    log_info "备份zsh历史记录..."
    mv ~/.zsh_history ~/.zsh_history.backup.$(date +%Y%m%d_%H%M%S)
    log_success "zsh历史记录已备份"
fi

echo
echo "========================================"
log_success "Zsh配置卸载完成！"
echo "========================================"
echo
echo "已完成的操作："
echo "- 默认shell已切换回bash"
echo "- .zshrc配置文件已备份并移除"
echo "- Oh My Zsh框架已移除"
echo "- 相关配置文件已备份"
echo
log_warning "请执行以下操作使更改生效："
echo "1. 重新登录系统"
echo "2. 或执行: exec bash"
echo
echo "备份文件位置："
echo "- ~/.zshrc.uninstall.backup.*"
echo "- ~/.zshrc.local.uninstall.backup.*"
echo "- ~/.zsh_history.backup.*"
echo
log_info "如需恢复zsh配置，请重新运行install-zsh.sh"