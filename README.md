# 《夜中余烬》(Ember in the Night: A Blacksmith's Tale)

一款铁匠题材的 RPG 与经营模拟（Godot）。

## 项目

| 项 | 值 |
|------|--------|
| 引擎 | Godot **4.7**（Forward Plus） |
| 呈现 | 2D（玩法原型：`app/` 下的锤子物理） |
| 物理 | Jolt（见 `project.godot` 配置） |
| 多人 | 无（单人项目） |
| Cloud Agents | Cursor Cloud 的工具安装定义在 [`.cursor/environment.json`](.cursor/environment.json)（运行 [`.cursor/install.sh`](.cursor/install.sh)） |

用 Godot 4.7+ 打开项目文件夹。主场景在 `project.godot` 中设置。

### 官方 Godot 文档（4.7）

| 主题 | 链接 |
|-------|------|
| Documentation home | https://docs.godotengine.org/en/4.7/ |
| Performance | https://docs.godotengine.org/en/4.7/tutorials/performance/ |
| Best practices | https://docs.godotengine.org/en/4.7/tutorials/best_practices/ |
| Engine details | https://docs.godotengine.org/en/4.7/engine_details/ |

### 布局（代码）

| 路径 | 角色 |
|------|------|
| `app/` | 正式玩法代码（实体、系统、关卡、资源、插件） |
| `app/entities/` | 游戏实体（锤子、金属等） |
| `app/systems/` | 控制器 / 交互系统 |
| `app/levels/` | 场景（主场景：锤子物理原型） |
| `app/resources/` | 共享资源（材质等） |
| `app/addons/` | 项目插件（如 gda harness autoload） |
| `art_style_demo/` | look-dev demo（非正式玩法）；用 F6 打开 |
| `Aseprite-User/` | 像素资源 submodule（跟踪 `main`）；源文件在 `src/`，游戏可读 `export/` |
| `docs/` | 游戏设计文档（不是对当前代码的描述） |

设计意图、主题与讨论见 [`docs/`](docs/)。参见 [`docs/README.md`](docs/README.md)。技术栈与环境事实留在本文件；`docs/tech/` 仅用于技术*讨论*。美术风格对比 demo 在仓库根目录：[`art_style_demo/`](art_style_demo/)。像素资源仓库：[`Aseprite-User/`](Aseprite-User/)（见其 [`README.md`](Aseprite-User/README.md)）。克隆本仓库后需初始化 submodule：

```bash
git submodule update --init --recursive
```

## 设定

中世纪世界是漫长之夜：行会规矩、社会律法与生存压力织成暗网，笼罩每一门手艺。你是一名铁匠。锻炉之火是你能握住的唯一光亮——**夜中余烬**。

游戏提供两条截然不同的道路，由同一簇火焰维系：

### 行会之路 (Guild Path)

扮演一名遵守行会规矩的铁匠，在混乱、压抑的中世纪社会中艰难经营铺子。在秩序与声望中求生。积累技艺、信任与影响力，直至成为在行会中有地位的大师工匠。

这是黑暗中的**守序坚持 (lawful resolve)**：守护生存与尊严的守序锻炉之火。

### 法外之路 (Outlaw Path)

扮演贫民窟或暗阁中的独立铁匠，拒绝行会——甚至拒绝律法。在监视与排斥之外谋生。守护一簇本不该公开燃烧的火。

这是**穿行夜色 (through the night)** 之路：另一种呵护生存之火的方式。

## 主题

- **锻炉之火** — 手艺、生计与希望；也是身份与选择的标记
- **漫长之夜** — 被行会、律法与阶级笼罩的社会
- **余烬** — 尚未熄灭的微光，须有人守护——无论靠秩序还是反抗

两条道路不是简单的善恶二分，而是同一片黑暗中的两种活法：一条在秩序内攀升；另一条在秩序外点燃自己的火。

设计侧文稿：[`docs/design/theme.md`](docs/design/theme.md)。
