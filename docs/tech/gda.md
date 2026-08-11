---
author: F
updated: 2026-08-09
status: active
---

# Godot Agent (`gda`) 集成

> **本文件：** 将 [godot-agent / `gda`](https://github.com/aigengame/godot-agent) 接入本 Godot 4.7 项目的技术路线笔记（CLI、Skill、Cursor MCP）以及端到端验证结果。不能替代上游文档。

## 为何需要

Agent 可以编辑 `.gd` / `.tscn` 文本，但除非有东西驱动 Godot 并返回**结构化 JSON**，否则看不到引擎加载错误、运行时场景树或物理状态。`gda` 就是这条回路：headless 项目操作，外加面向正在运行的主场景的 live daemon。

## 集成路径（同一命令面）

| 路径 | 适用时机 |
|------|----------|
| CLI (`gda … --json`) | Shell、脚本、CI、无 MCP 的 Cloud Agents |
| Skill (`gda skill`) | 加载 Skill 包并调用 CLI 的 agents |
| MCP (`gda-mcp`) | Cursor / Claude Code / Codex 的 tool calls |

本仓库在 [`.cursor/mcp.json`](../../.cursor/mcp.json) 注册 Cursor MCP（`GDA_PROJECT=${workspaceFolder}`）。在机器上安装一次：Python **3.13+**、[`uv`](https://docs.astral.sh/uv/) / `uvx`、Godot **4.7+** 在 `PATH` 上或设置 `GDA_GODOT`。可选：`uv tool install 'gda[mcp]'`，把固定的 `gda` / `gda-mcp` 放到 `PATH`。

对 **Cursor Cloud Agents**，相同固定版本由 [`.cursor/environment.json`](../../.cursor/environment.json) → [`.cursor/install.sh`](../../.cursor/install.sh) 安装（Cursor 不会仅凭名称安装工具；脚本必须运行）。

编辑 MCP 配置后重载 Cursor（Settings → Tools & MCP）。若 Cursor GUI 的 `PATH` 下缺少 `uvx`，保留 `.cursor/mcp.json` 中的 `PATH` 修复，或把 `command` 设为 `uvx` 的绝对路径（`which uvx`）。

## Live harness（已提交）

`gda daemon start` 会安装惰性的 autoload harness。本项目保留它，以免首次使用 live 操作时改写工程树：

- `app/addons/gda_harness/gda_harness.gd`
- `project.godot` → `[autoload] GdaHarness=*`

若不需要 live 控制，可用 `gda daemon uninstall` 移除。Headless 命令不需要 harness。

## 实用工作流

1. 设置环境：`export GDA_PROJECT=/path/to/Ember-in-the-Night`；若 Godot 不在 `PATH` 上则设置 `GDA_GODOT`。
2. 预热 `.godot` 一次（class cache / UIDs）：`godot --path "$GDA_PROJECT" --headless --import`。
3. Headless 查看/编辑：`gda project info --json`、`gda scene get app/levels/test_scene.tscn --json`，…
4. Live：`gda daemon start`（`screen capture` 时加 `--windowed`），然后 `game` / `perf` / `input` / `diag`，再 `gda daemon stop`。

上游注册配方：[gda-mcp-registration.md](https://github.com/aigengame/godot-agent/blob/main/docs/gda-mcp-registration.md)。

## 验证（2026-08-07，gda 0.9.0 + Godot 4.7.1）

针对本仓库主场景（`app/levels/test_scene.tscn`）做过的检查：

| 检查 | 结果 |
|-------|---------|
| `gda info` / `project info` / `statistics` | OK |
| `scene get` / `script get` | import 后 OK；import 前 stderr 可能出现 UID / `BaseEntity` 噪声，stdout JSON 仍可能返回 |
| `daemon start` + `game tree` | 运行时树匹配 Metal / Hammer / Platform / Camera2D / DragController |
| `game get … --property position` | Live `RigidBody2D` 位置 |
| `perf monitors` | 例如 `node_count=14`、`physics_2d_active_objects=2` |
| `diag errors` | 空 |
| `input action grab` / `input mouse-click` | 已接受 |
| `gda-mcp` `initialize` + `tools/list` | **67** 个 tools |
| `screen capture`（`--windowed`） | API OK；在 cloud/VNC 会话中捕获为空白暗帧——像素捕获视为依赖环境 |

## 未决问题

- cloud / headless 显示服务器能否在无额外渲染标志时，为本 Forward+ 2D demo 产出有用的 `screen capture`。
- 是否还要为非 MCP agents 提供 `gda skill` 安装（CLI-only 路径已可用）。
