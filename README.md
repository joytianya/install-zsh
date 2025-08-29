# Zsh 一键安装配置脚本

一键安装并配置 Zsh + Oh My Zsh 的便捷脚本，适用于 Ubuntu/Debian/CentOS/RHEL 系统。

## 特性

- ✅ 自动检测操作系统
- ✅ 安装 Zsh 及必要依赖
- ✅ 安装 Oh My Zsh 框架
- ✅ 配置常用插件（autosuggestions, syntax-highlighting）
- ✅ 优化的 .zshrc 配置
- ✅ 切换默认 shell
- ✅ 生成卸载脚本
- ✅ 错误处理和回滚机制
- ✅ 彩色输出和详细日志

## 快速使用

### 方法一：直接执行（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/joytianya/install-zsh/main/install-zsh.sh | bash
```

### 方法二：下载后执行

```bash
wget https://raw.githubusercontent.com/joytianya/install-zsh/main/install-zsh.sh
chmod +x install-zsh.sh
./install-zsh.sh
```

### 方法三：克隆仓库

```bash
git clone https://github.com/joytianya/install-zsh.git
cd install-zsh
chmod +x install-zsh.sh
./install-zsh.sh
```

## 安装内容

### 软件包
- **zsh**: Z Shell 主程序
- **curl**: 下载工具
- **git**: 版本控制工具

### Oh My Zsh 框架
- **主题**: agnoster（美观的 PowerLine 主题）
- **插件**: 
  - `git`: Git 命令别名和状态显示
  - `zsh-autosuggestions`: 命令自动建议
  - `zsh-syntax-highlighting`: 语法高亮
  - `history-substring-search`: 历史命令搜索
  - `colored-man-pages`: 彩色 man 页面
  - `command-not-found`: 命令未找到提示

### 配置优化
- 历史记录优化（10000 条记录）
- 自动纠错功能
- 智能补全配置
- SSH 连接优化
- 常用别名设置

## 系统要求

### 支持的操作系统
- Ubuntu 16.04+
- Debian 9+
- CentOS 7+
- RHEL 7+
- Fedora 30+

### 权限要求
- 需要 sudo 权限安装软件包
- 不能以 root 用户运行

## 安装后使用

### 立即生效
```bash
exec zsh
# 或
source ~/.zshrc
```

### 重新登录
退出当前会话并重新登录系统

## 卸载方法

脚本会自动生成卸载脚本：

```bash
~/uninstall-zsh.sh
```

或手动卸载：

```bash
# 切换回 bash
chsh -s /bin/bash

# 删除配置文件
rm -rf ~/.oh-my-zsh
mv ~/.zshrc ~/.zshrc.backup

# 重新登录生效
```

## 自定义配置

### 本地配置文件
创建 `~/.zshrc.local` 文件添加个人配置：

```bash
# 个人别名
alias myproject='cd ~/projects/myproject'

# 环境变量
export PATH="$HOME/bin:$PATH"

# 自定义函数
myfunc() {
    echo "Hello, $1!"
}
```

### 主题更换
编辑 `~/.zshrc` 文件：

```bash
# 更换主题
ZSH_THEME="robbyrussell"  # 或其他主题
```

常用主题：
- `robbyrussell`（默认简洁主题）
- `agnoster`（PowerLine 风格）
- `powerlevel10k`（需要额外安装）

## 故障排除

### 字体显示问题
如果使用 agnoster 主题出现乱码，需要安装 PowerLine 字体：

```bash
# Ubuntu/Debian
sudo apt install fonts-powerline

# 或手动安装 Nerd Fonts
```

### 插件不工作
重新加载配置：

```bash
source ~/.zshrc
```

### 权限问题
确保以普通用户运行脚本，不要使用 root：

```bash
# 错误
sudo ./install-zsh.sh

# 正确
./install-zsh.sh
```

## 高级用法

### 环境变量配置
```bash
# 编辑器设置
export EDITOR='code'  # 或 nano, vim

# 语言设置
export LANG=zh_CN.UTF-8

# 自定义 PATH
export PATH="$HOME/.local/bin:$PATH"
```

### 函数和别名
```bash
# 创建目录并进入
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Git 快捷命令
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
```

## 更新日志

### v1.0.0
- 初始版本发布
- 支持主流 Linux 发行版
- 基础插件和主题配置
- 自动化安装流程

## 贡献指南

欢迎提交 Issue 和 Pull Request！

### 开发环境
```bash
git clone https://github.com/joytianya/install-zsh.git
cd install-zsh
```

### 测试
在虚拟机或容器中测试脚本：

```bash
# Docker 测试
docker run -it ubuntu:20.04 bash
# 在容器中运行脚本测试
```

## 许可证

MIT License

## 支持

如有问题，请：
1. 查看 [FAQ](#故障排除)
2. 提交 [Issue](https://github.com/joytianya/install-zsh/issues)
3. 参考 [Oh My Zsh 官方文档](https://ohmyz.sh/)

---

**⭐ 如果这个脚本对你有帮助，请给个 Star！**