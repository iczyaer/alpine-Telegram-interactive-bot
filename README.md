# Alpine Linux 一键安装 Telegram 互动机器人脚本

[![Stargazers](https://img.shields.io/github/stars/iczyaer/alpine-Telegram-interactive-bot)](https://github.com/iczyaer/alpine-Telegram-interactive-bot/stargazers) 
[![Issues](https://img.shields.io/github/issues/iczyaer/alpine-Telegram-interactive-bot)](https://github.com/iczyaer/alpine-Telegram-interactive-bot/issues)

> 基于 Alpine Linux 的 Telegram 互动机器人（Telegram-interactive-bot）一键安装与环境配置脚本，支持交互式参数配置、依赖自动安装及虚拟环境隔离。

---

## 项目简介

本项目为 **Telegram-interactive-bot** 提供 Alpine Linux 系统的一键安装解决方案，主要功能包括：
- 自动安装系统依赖（Python3、SQLite、构建工具等）
- 创建专用工作目录并克隆项目代码
- 配置 Python 虚拟环境隔离依赖
- 交互式生成 `.env` 配置文件（含机器人 Token、管理群组、消息策略等核心参数）
- 记录详细安装日志，便于问题排查

---

## 适用系统

- **Alpine Linux**（脚本已针对 Alpine 包管理工具 `apk` 优化）

---

## 功能特性

- **交互式配置**：通过命令行交互输入机器人核心参数（Token、管理群组、消息间隔等），自动生成 `.env` 文件
- **依赖隔离**：使用 Python 虚拟环境（`venv`）管理项目依赖，避免与系统全局包冲突
- **日志记录**：全程记录安装过程日志至 `/var/log/telegram-bot-install.log`，便于故障排查
- **适配优化**：修复 Alpine Linux 下 PEP 668 兼容性问题，解决 `pkg_resources` 模块缺失问题
- **开箱即用**：安装完成后提供明确的运行指导，支持快速启动与长期部署

---

## 安装前准备

1. **系统要求**：确保当前系统为 **Alpine Linux**（可通过 `cat /etc/os-release` 验证）
2. **权限要求**：需以 **root 用户** 或使用 `sudo` 运行脚本（脚本会检查权限）
3. **网络要求**：需能访问 GitHub（克隆项目代码）及 Telegram Bot API（后续机器人运行需要）
4. **基础工具**：Alpine 已预装 `git`、`apk` 等工具，无需额外安装

---

## 安装步骤

### 1. 下载脚本
# 克隆脚本仓库（或直接下载 install.sh）
git clone https://github.com/iczyaer/alpine-Telegram-interactive-bot.git
cd alpine-Telegram-interactive-bot

未完成。。。
