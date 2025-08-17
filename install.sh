#!/bin/sh

# 一键安装脚本 for Telegram-interactive-bot on Alpine Linux
# 项目地址: https://github.com/MiHaKun/Telegram-interactive-bot/
# 适用于 Alpine Linux 系统，安装依赖并准备环境，不自动启动项目
# 特性: 交互式输入完整配置，记录安装日志，适配 PEP 668，修复 pkg_resources

# 定义日志文件
LOG_FILE="/var/log/telegram-bot-install.log"
mkdir -p /var/log
touch "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始安装 Telegram-interactive-bot" >> "$LOG_FILE"

# 提示用户
echo "=============================================================="
echo "本脚本将为 Alpine Linux 系统安装项目依赖并准备环境。"
echo "日志将记录在 $LOG_FILE，安装出错时可查看日志。"
echo "如有问题，可加入讨论群组: https://t.me/DeveloperTeamGroup"
echo "=============================================================="

# 检查 root 权限
if [ "$(id -u)" -ne 0 ]; then
    echo "[错误] 请以 root 或 sudo 权限运行此脚本！"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: 未使用 root 权限" >> "$LOG_FILE"
    exit 1
fi

# 更新包索引并安装基本依赖
echo "正在更新 Alpine Linux 包索引并安装依赖..."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 更新包索引并安装 git、python3、sqlite 等" >> "$LOG_FILE"
apk update && apk upgrade >> "$LOG_FILE" 2>&1
apk add --no-cache git python3 py3-pip python3-dev build-base sqlite py3-virtualenv >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo "[错误] 安装系统依赖失败，请检查 $LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: 安装系统依赖失败" >> "$LOG_FILE"
    exit 1
fi
echo "系统依赖安装完成！"

# 设置工作目录
WORK_DIR="/opt/telegram-interactive-bot"
if [ -d "$WORK_DIR" ]; then
    echo "目录 $WORK_DIR 已存在，将删除并重新创建..."
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 删除并重新创建 $WORK_DIR" >> "$LOG_FILE"
    rm -rf "$WORK_DIR" >> "$LOG_FILE" 2>&1
fi
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || { echo "[错误] 无法进入目录 $WORK_DIR，请检查 $LOG_FILE"; echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: 无法进入 $WORK_DIR" >> "$LOG_FILE"; exit 1; }
echo "工作目录 $WORK_DIR 已准备好！"

# 克隆项目代码
echo "正在克隆 Telegram-interactive-bot 项目..."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 克隆项目代码" >> "$LOG_FILE"
git clone https://github.com/MiHaKun/Telegram-interactive-bot.git . >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo "[错误] 克隆项目失败，请检查网络连接或 $LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: 克隆项目失败" >> "$LOG_FILE"
    exit 1
fi
echo "项目代码克隆完成！"

# 创建 Python 虚拟环境
echo "正在创建 Python 虚拟环境..."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 创建虚拟环境" >> "$LOG_FILE"
python3 -m venv venv >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo "[错误] 创建虚拟环境失败，请检查 $LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: 创建虚拟环境失败" >> "$LOG_FILE"
    exit 1
fi
echo "虚拟环境创建完成！"

# 激活虚拟环境并安装依赖
echo "正在安装项目依赖（包括 setuptools）..."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 安装项目依赖和 setuptools" >> "$LOG_FILE"
. venv/bin/activate
pip install --no-cache-dir setuptools >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo "[错误] 安装 setuptools 失败，请检查 $LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: 安装 setuptools 失败" >> "$LOG_FILE"
    exit 1
fi
pip install --no-cache-dir -r requirements.txt >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo "[错误] 安装项目依赖失败，请检查 $LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: 安装依赖失败" >> "$LOG_FILE"
    exit 1
fi
echo "项目依赖安装完成！"

# 交互式输入配置
echo ""
echo "=============================================================="
echo "请按照提示输入配置信息以生成 .env 文件："
echo ""

# 输入 BOT_TOKEN
echo "请输入 BOT_TOKEN（通过 @BotFather 获取）："
read -r BOT_TOKEN
if [ -z "$BOT_TOKEN" ]; then
    echo "[错误] BOT_TOKEN 不能为空！"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: BOT_TOKEN 为空" >> "$LOG_FILE"
    exit 1
fi
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已输入 BOT_TOKEN" >> "$LOG_FILE"

# 输入 ADMIN_GROUP_ID
echo "请输入 ADMIN_GROUP_ID（通过 @GetTheirIDBot 获取管理群组 ID，例如 -1002234110823）："
read -r ADMIN_GROUP_ID
if [ -z "$ADMIN_GROUP_ID" ]; then
    echo "[错误] ADMIN_GROUP_ID 不能为空！"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: ADMIN_GROUP_ID 为空" >> "$LOG_FILE"
    exit 1
fi
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已输入 ADMIN_GROUP_ID" >> "$LOG_FILE"

# 输入 ADMIN_USER_IDS
echo "请输入 ADMIN_USER_IDS（通过 @GetTheirIDBot 获取管理员用户 ID，多个 ID 用逗号分隔，例如 1281631753,1022318030）："
read -r ADMIN_USER_IDS
if [ -z "$ADMIN_USER_IDS" ]; then
    echo "[错误] ADMIN_USER_IDS 不能为空！"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: ADMIN_USER_IDS 为空" >> "$LOG_FILE"
    exit 1
fi
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已输入 ADMIN_USER_IDS" >> "$LOG_FILE"

# 输入 WELCOME_MESSAGE
echo "请输入 WELCOME_MESSAGE（留空使用默认值：'你好，我是米哈（ @MrMiHa ）。请问有什么可以帮助你的吗？'）："
read -r WELCOME_MESSAGE
if [ -z "$WELCOME_MESSAGE" ]; then
    WELCOME_MESSAGE="你好，我是米哈（ @MrMiHa ）。\n请问有什么可以帮助你的吗？\n和这个示例机器人对话后，可以前往：https://t.me/MiHaCMSGroup 查看效果。\n有问题，请访问：https://github.com/MiHaKun/Telegram-interactive-bot 查看代码或提出issue（顺便求star）"
fi
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已输入 WELCOME_MESSAGE" >> "$LOG_FILE"

# 输入 DELETE_TOPIC_AS_FOREVER_BAN
echo "请输入 DELETE_TOPIC_AS_FOREVER_BAN（是否永久封禁删除话题，输入 TRUE 或 FALSE，默认为 FALSE）："
read -r DELETE_TOPIC_AS_FOREVER_BAN
if [ -z "$DELETE_TOPIC_AS_FOREVER_BAN" ]; then
    DELETE_TOPIC_AS_FOREVER_BAN="FALSE"
fi
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已输入 DELETE_TOPIC_AS_FOREVER_BAN" >> "$LOG_FILE"

# 输入 DELETE_USER_MESSAGE_ON_CLEAR_CMD
echo "请输入 DELETE_USER_MESSAGE_ON_CLEAR_CMD（是否清理用户侧消息，输入 TRUE 或 FALSE，默认为 TRUE）："
read -r DELETE_USER_MESSAGE_ON_CLEAR_CMD
if [ -z "$DELETE_USER_MESSAGE_ON_CLEAR_CMD" ]; then
    DELETE_USER_MESSAGE_ON_CLEAR_CMD="TRUE"
fi
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已输入 DELETE_USER_MESSAGE_ON_CLEAR_CMD" >> "$LOG_FILE"

# 输入 DISABLE_CAPTCHA
echo "请输入 DISABLE_CAPTCHA（是否禁用人机识别，输入 TRUE 或 FALSE，默认为 FALSE）："
read -r DISABLE_CAPTCHA
if [ -z "$DISABLE_CAPTCHA" ]; then
    DISABLE_CAPTCHA="FALSE"
fi
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已输入 DISABLE_CAPTCHA" >> "$LOG_FILE"

# 输入 MESSAGE_INTERVAL
echo "请输入 MESSAGE_INTERVAL（消息间隔秒数，0 为不限制，默认为 5）："
read -r MESSAGE_INTERVAL
if [ -z "$MESSAGE_INTERVAL" ]; then
    MESSAGE_INTERVAL="5"
fi
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已输入 MESSAGE_INTERVAL" >> "$LOG_FILE"

# 写入 .env 文件
echo "正在生成 .env 文件..."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 生成 .env 文件" >> "$LOG_FILE"
cat > .env << EOF
# 基本配置
APP_NAME=interactive-bot
BOT_TOKEN=$BOT_TOKEN

# 业务配置
WELCOME_MESSAGE=$WELCOME_MESSAGE
ADMIN_GROUP_ID=$ADMIN_GROUP_ID
ADMIN_USER_IDS=$ADMIN_USER_IDS
DELETE_TOPIC_AS_FOREVER_BAN=$DELETE_TOPIC_AS_FOREVER_BAN
DELETE_USER_MESSAGE_ON_CLEAR_CMD=$DELETE_USER_MESSAGE_ON_CLEAR_CMD
DISABLE_CAPTCHA=$DISABLE_CAPTCHA
MESSAGE_INTERVAL=$MESSAGE_INTERVAL
EOF
if [ $? -ne 0 ]; then
    echo "[错误] 生成 .env 文件失败，请检查 $LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: 生成 .env 文件失败" >> "$LOG_FILE"
    exit 1
fi
chmod 600 .env >> "$LOG_FILE" 2>&1
echo "已生成 .env 文件并设置权限！"

# 输出详细的后续操作提示
echo ""
echo "=============================================================="
echo "🎉 安装和配置完成！请按照以下步骤运行项目："
echo ""
echo "1. 运行项目："
echo "   cd $WORK_DIR"
echo "   . venv/bin/activate"
echo "   python -m interactive-bot"
echo ""
echo "2. 长期运行建议："
echo "   使用 PM2 或 supervisor 管理进程，详见项目 README。"
echo "   README 地址: https://github.com/MiHaKun/Telegram-interactive-bot/blob/master/README.en.md"
echo ""
echo "3. 遇到问题？"
echo "   - 查看日志: cat $LOG_FILE"
echo "   - 检查 .env 文件: cat $WORK_DIR/.env"
echo "   - 加入讨论群组: https://t.me/DeveloperTeamGroup"
echo "=============================================================="
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 安装和配置完成，等待用户运行" >> "$LOG_FILE"

exit 0
