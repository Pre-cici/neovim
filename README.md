# Neovim Workshop

一套面向日常开发、技术写作与终端工作流的个人 Neovim 配置。配置以 Lua 模块化组织，使用
[lazy.nvim](https://github.com/folke/lazy.nvim) 管理插件，并围绕 Python、Markdown、LaTeX、Git、调试和
OpenCode 做了较完整的集成。

> 这是个人配置，不是通用发行版。当前主要在 macOS、Neovim 0.12 和 Kitty/tmux 环境下使用。

## 特性

- Catppuccin Macchiato 主题、透明背景、自定义 Alpha Dashboard 和 Heirline 状态栏
- Snacks picker、Oil 文件浏览器、Edgy 侧栏和持久化会话
- Neovim 原生 LSP：LuaLS、Pyright、Ruff、Marksman 和 clangd
- Blink 补全、LuaSnip 代码片段和 Treesitter textobjects
- Conform 手动格式化，Mason 自动安装语言工具
- Python 虚拟环境选择、Overseer 任务运行和 Debugpy 调试
- Markdown 实时渲染、任务状态、浏览器预览和剪贴板图片
- VimTeX、latexmk、Skim 和 SyncTeX 写作链路
- LeetCode 中国站与 Python 3 工作流
- OpenCode 侧栏，支持 tmux pane 和内置 Snacks terminal

## 预览

启动页使用自定义 `WORKSHOP` Dashboard，提供文件搜索、项目、会话、LeetCode、配置和插件管理入口。
界面组件主要由 Catppuccin、Alpha、Heirline、Incline、Noice 和 Edgy 组成。

## 环境要求

### 基础依赖

- [Neovim](https://neovim.io/) 0.11 或更高版本
- Git
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- 支持图标的 Nerd Font
- C 编译工具链，用于必要时编译 Treesitter parser

Mason 会在首次使用时安装以下工具：

- `lua-language-server`
- `pyright`
- `ruff`
- `marksman`
- `clangd`
- `stylua`
- `prettier`
- Python DAP adapter（Debugpy）

### 可选依赖

| 工具         | 用途                                           |
| ------------ | ---------------------------------------------- |
| `lazygit`    | Git TUI；安装后启用 `<Space>gg` 和 `<Space>gG` |
| `yazi`       | 外部终端文件管理器                             |
| `tmux`       | 跨 pane 导航和独立 OpenCode pane               |
| `fd`         | 搜索 Mamba Python 环境                         |
| Python 3     | Python 运行、分析和调试                        |
| Node.js/npm  | Markdown Preview 等插件的构建环境              |
| OpenCode CLI | Neovim 中的 AI 侧栏                            |
| `latexmk`    | VimTeX LaTeX 编译                              |
| Skim         | macOS PDF 预览与 SyncTeX                       |

VimTeX 当前明确配置为 `latexmk + Skim`，因此 PDF 预览部分是 macOS 专用的。系统剪贴板在 SSH 会话中会自动禁用。

## 安装

先备份已有配置：

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

克隆仓库：

```bash
git clone https://github.com/Pre-cici/neovim.git ~/.config/nvim
nvim
```

首次启动时会自动安装 lazy.nvim 和插件。打开一个代码文件后，Mason 会继续安装配置中声明的 LSP、formatter
和 debugger。

常用维护命令：

```vim
:Lazy          " 插件管理
:Mason         " 外部工具管理
:checkhealth   " 环境检查
:ConformInfo   " formatter 状态
:checkhealth vim.lsp  " LSP 状态
```

## 目录结构

```text
.
├── init.lua                 # 启动入口
├── lua/
│   ├── config/              # options、keymaps、autocmds、LSP 生命周期
│   ├── plugins/             # 按功能拆分的 lazy.nvim plugin specs
│   └── utils/               # root、Python、terminal 等共享逻辑
├── lsp/                     # Neovim 0.11+ 原生 LSP server 配置
├── after/ftplugin/          # 文件类型局部设置与按键
├── lazy-lock.json           # 插件版本锁
└── .stylua.toml             # Lua 格式规则
```

启动顺序：

```text
init.lua
  -> config.options
  -> config.keymaps
  -> config.autocmds
  -> config.lsp
  -> plugins
```

新增插件模块后，还需要在 `lua/plugins/init.lua` 的 `spec` 中显式导入。新增 LSP 时通常需要同时修改：

1. `lsp/<server>.lua`
2. `lua/config/lsp.lua` 中的 `vim.lsp.enable(...)`
3. `lua/plugins/lspconfig.lua` 中 Mason 的 `ensure_installed`

## 核心工作流

### 搜索与文件

Snacks picker 默认从当前 Git 根目录搜索；Oil 使用可编辑目录 buffer 完成文件操作。

| 按键                      | 功能                                |
| ------------------------- | ----------------------------------- |
| `<Space><Space>`          | 查找项目文件                        |
| `<Space>ff`               | 查找文件，包括隐藏文件              |
| `<Space>/` / `<Space>sg`  | 项目内实时搜索                      |
| `<Space>sw`               | 搜索光标下单词                      |
| `<Space>sb` / `<Space>sB` | 搜索当前 buffer / 所有打开的 buffer |
| `<Space>fr`               | 最近文件                            |
| `<Space>fp`               | 项目列表                            |
| `<Space>bb`               | Buffer picker                       |
| `<Space>e`                | 打开 Oil                            |
| `<Space>fn` / `<Space>fw` | 新建文件 / 保存文件                 |

### Buffer、窗口与终端

| 按键                  | 功能                                 |
| --------------------- | ------------------------------------ |
| `Shift-h` / `Shift-l` | 上一个 / 下一个 buffer               |
| `<Space>bd`           | 删除当前 buffer                      |
| `<Space>bo`           | 删除其他 buffer                      |
| `Ctrl-h/j/k/l`        | 在 Neovim window 或 tmux pane 间移动 |
| `<Space>wd`           | 关闭窗口                             |
| `<Space>tt`           | 切换底部终端                         |
| `<Space><Tab><Tab>`   | 新建 tab                             |
| `<Space><Tab>]`       | 下一个 tab                           |

`<leader>` 和 `<localleader>` 都是空格。宏录制键从 `q` 移到了 `Q`。

### LSP、诊断与格式化

| 按键        | 功能                          |
| ----------- | ----------------------------- |
| `gd`        | 跳转到定义                    |
| `K`         | LSP hover                     |
| `gK`        | Signature help                |
| `<Space>cA` | Code action                   |
| `<Space>cl` | 当前 buffer 的 LSP 信息       |
| `<Space>th` | 切换 inlay hints              |
| `<Space>cf` | 使用 Conform 格式化           |
| `<Space>cd` | 当前行诊断                    |
| `]d` / `[d` | 下一个 / 上一个诊断           |
| `]e` / `[e` | 下一个 / 上一个错误           |
| `<Space>xx` | Trouble workspace diagnostics |

格式化默认不会在保存时自动执行：

| 文件类型             | Formatter                               |
| -------------------- | --------------------------------------- |
| Lua                  | Stylua                                  |
| Python               | Ruff fix、organize imports、Ruff format |
| Markdown             | Prettier                                |
| JSON / JSONC / JSONL | Prettier                                |

Python 中由 Pyright 负责分析和 hover，Ruff 负责 lint、修复和格式化。解释器优先级为：venv-selector 当前选择、
项目 `.venv`、`VIRTUAL_ENV`、`CONDA_PREFIX`、系统 `python3`。

### Python 运行与调试

| 按键               | 功能                               |
| ------------------ | ---------------------------------- |
| `<Space>cv`        | 选择 Python 虚拟环境               |
| `<Space>or`        | 通过 Overseer 运行当前 Python 文件 |
| `<Space>ow`        | 切换任务列表                       |
| `<Space>db`        | 切换断点                           |
| `<Space>dB`        | 条件断点                           |
| `F5` / `F6`        | 开始或继续 / 暂停                  |
| `F1` / `F2` / `F3` | Step into / over / out             |
| `F7`               | 切换 DAP UI                        |
| `F8` / `F9`        | 终止 / 重跑上次调试                |
| `<Space>de`        | Evaluate expression                |

Overseer 会在检测到的项目根目录运行文件，并只为当前任务设置 `PYTHONPATH`。DAP 使用同一套活动解释器选择逻辑。

### Git

| 按键                      | 功能                          |
| ------------------------- | ----------------------------- |
| `<Space>gg`               | 在当前 Git 根目录打开 Lazygit |
| `<Space>gG`               | 在当前工作目录打开 Lazygit    |
| `]c` / `[c`               | 下一个 / 上一个 Git hunk      |
| `<Space>gs` / `<Space>gr` | Stage / reset hunk            |
| `<Space>gp`               | Preview hunk                  |
| `<Space>gb`               | 当前行 blame                  |
| `<Space>gd`               | 与 index 比较                 |

Lazygit 快捷键仅在系统能够找到 `lazygit` 时注册。

### Markdown

| 按键                  | 功能                            |
| --------------------- | ------------------------------- |
| `<Space>tm`           | 切换 Markdown 渲染              |
| `<Space>mp`           | 切换浏览器预览                  |
| `<Space>mc`           | 切换任务状态                    |
| Visual `Ctrl-b/i/s/c` | 粗体 / 斜体 / 删除线 / 行内代码 |
| `Alt-o` / `Alt-O`     | 在下方 / 上方插入列表项         |
| `<Space>mr`           | 重新编号列表                    |
| `<Space>p`            | 粘贴剪贴板图片                  |

Markdown buffer 会启用换行和拼写检查，并由 Marksman 提供链接、符号和跳转能力。

### LaTeX

VimTeX 保留默认的 buffer-local 映射：

| 按键        | 功能                     |
| ----------- | ------------------------ |
| `<Space>ll` | 启动或停止持续编译       |
| `<Space>lv` | 在 Skim 中查看并正向同步 |
| `<Space>le` | 查看编译错误             |
| `<Space>lt` | 打开目录                 |

编译链路为：

```text
Neovim -> VimTeX -> latexmk -> PDF -> Skim
```

Skim 需要单独配置 inverse search，才能通过 SyncTeX 从 PDF 返回 Neovim。

### OpenCode

需要提前安装并配置 [OpenCode](https://opencode.ai/)。Neovim 启动独立的固定地址 `opencode serve`，
`opencode.nvim` 只负责 API、上下文与文件重载；tmux pane 或 Edgy 右侧 Snacks terminal 通过
`opencode attach` 显示 TUI。

| 按键                | 功能                        |
| ------------------- | --------------------------- |
| `<Space>ac`         | 打开或切换 OpenCode         |
| `Ctrl-.`            | 在 terminal 中切换 OpenCode |
| `<Space>aa`         | 将当前上下文提交给 OpenCode |
| `<Space>as`         | 选择 OpenCode action        |
| `goo` / visual `go` | 发送当前行或 visual range   |
| `Alt-u` / `Alt-d`   | 滚动 OpenCode session       |
| Picker 中 `Alt-a`   | 将选中结果发送给 OpenCode   |
| `:OpencodeStop`     | 停止 OpenCode 进程          |

为了避免 Kitty graphics capability reply 污染 Neovim 输入，TUI 以 `OPENTUI_GRAPHICS=false` 启动。

### LeetCode

运行 `:Leet` 进入 LeetCode 界面。当前默认使用中国站、中文题目和 Python 3。进入题目 buffer 后：

| 按键        | 功能              |
| ----------- | ----------------- |
| `<Space>ll` | 题目列表          |
| `<Space>lr` | 运行              |
| `<Space>ls` | 提交              |
| `<Space>lc` | Console           |
| `<Space>lf` | 题目信息          |
| `<Space>li` | 注入模板或 import |

这些映射只存在于 LeetCode 题目 buffer，不会覆盖 VimTeX 的 `<Space>ll`。

## 验证与维护

仓库使用 StyLua，主要规则为 2 空格缩进和 120 列宽：

```bash
stylua --check .
```

修改配置后至少执行：

```bash
nvim --headless +qa
git diff --check
```

涉及终端、调试、VimTeX、Markdown 渲染或 OpenCode 的修改仍应在实际 Neovim UI 中进行 smoke test。

## 说明

- 自动保存格式化刻意关闭，请使用 `<Space>cf`。
- OpenCode、Yazi、Lazygit、Skim 和 LaTeX 工具链都属于可选外部依赖。
- Python、Mamba 和 Homebrew 搜索路径包含当前机器的 macOS 约定，移植到 Linux 前需要调整。
- 插件版本由 `lazy-lock.json` 固定；升级前建议先提交当前配置并检查 `:Lazy log`。
