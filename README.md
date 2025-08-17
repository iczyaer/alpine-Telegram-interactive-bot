## alpine-Telegram-interactive-bot

适用于 Alpine Linux 的 Telegram-interactive-bot 一键安装脚本

## 项目介绍

本仓库提供一个一键安装脚本，用于在 Alpine Linux 系统上快速部署 [Telegram-interactive-bot](https://github.com/MiHaKun/Telegram-interactive-bot/) 项目。

脚本特性：
- 自动安装系统依赖和项目依赖
- 配置 Python 虚拟环境（适配 PEP 668）
- 修复 pkg_resources 相关问题
- 详细的安装日志记录
- 清晰的操作提示

## 安装步骤

1. 登录到 Alpine Linux 系统，确保拥有 root 权限
2. 执行以下命令：

```bash
wget https://raw.githubusercontent.com/iczyaer/alpine-Telegram-interactive-bot/main/install.sh && chmod +x install.sh && ./install.sh
```

## 后续配置

安装完成后，请按照以下步骤配置和运行项目：

1. 编辑配置文件：
   ```bash
   nano /opt/telegram-interactive-bot/.env
   ```
   
   需要填写的关键信息：
   - `BOT_TOKEN`: 从 @BotFather 获取
   - `GROUP_ID`: 管理群组 ID（可通过 @GetTheirIDBot 获取）
   - `ADMIN_ID`: 管理员用户 ID（可通过 @GetTheirIDBot 获取）

2. 运行项目：
   ```bash
   cd /opt/telegram-interactive-bot
   . venv/bin/activate
   python -m interactive-bot
   ```

## 日志查看

安装过程中的日志记录在：
```bash
cat /var/log/telegram-bot-install.log
```

## 长期运行建议

为了确保机器人在后台稳定运行，建议使用进程管理工具：

- PM2
- supervisor

具体配置方法请参考原项目的 README：
[https://github.com/MiHaKun/Telegram-interactive-bot/blob/master/README.en.md](https://github.com/MiHaKun/Telegram-interactive-bot/blob/master/README.en.md)

## 问题反馈

如果遇到安装问题，可以：
1. 检查安装日志
2. 加入原项目讨论群组：[https://t.me/DeveloperTeamGroup](https://t.me/DeveloperTeamGroup)
3. 在本仓库提交 Issue

## 许可证

本项目的安装脚本遵循 MIT 许可证，原项目许可证请参考其仓库说明。
