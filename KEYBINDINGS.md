# Emacs 快捷键速查表 (Keybindings Cheat Sheet)

本项目使用 `C-c` (Ctrl + C) 作为全局的**队长键 (Leader Key)**，所有的快捷键都按功能模块进行了科学的分类。

> **提示：** 配合配置中自带的 `which-key` 插件，您只需按下 `C-c` 并在屏幕底部停留 0.3 秒，系统会自动弹出下面所有的按键提示，无需死记硬背！

---

## 📂 1. 文件与基础 (File & Basics) - 前缀 `C-c f` / `C-c b` / `C-c w`

| 快捷键 | 功能 | 命令 |
| :--- | :--- | :--- |
| `C-c f f` | 打开文件 | `find-file` |
| `C-c f s` | 保存当前文件 | `save-buffer` |
| `C-c f r` | 打开最近打开过的历史文件 | `recentf-open-files` |
| `C-c b b` | 切换 Buffer | `switch-to-buffer` |
| `C-c b k` | 关闭当前 Buffer | `kill-buffer` |
| `C-c b r` | 重新加载当前文件 (Revert) | `revert-buffer` |
| `C-c w v` | 左右垂直分割窗口 | `split-window-right` |
| `C-c w s` | 上下水平分割窗口 | `split-window-below` |
| `C-c w d` | 删除当前光标所在的窗口 | `delete-window` |
| `C-c w o` | 最大化当前窗口（关闭其他所有窗口） | `delete-other-windows` |

---

## 📦 2. 项目管理 (Project) - 前缀 `C-c p`

*基于原生的 project.el 提供轻量、高效的工程管理。*

| 快捷键 | 功能 | 命令 |
| :--- | :--- | :--- |
| `C-c p f` | 在整个项目中按名称搜索文件 | `project-find-file` |
| `C-c p p` | 在不同的项目历史之间进行快速切换 | `project-switch-project` |
| `C-c p s` | 在项目中进行全局内容搜索 (Grep) | `project-search` |
| `C-c p c` | 编译当前项目 | `project-compile` |

---

## 💻 3. 代码与智能提示 (Code & LSP) - 前缀 `C-c c`

*这些快捷键会在您的代码文件 (C++, Python 等) 配合 Eglot 自动生效。*

| 快捷键 | 功能 | 命令 |
| :--- | :--- | :--- |
| `C-c c d` | 跳转到光标处的函数/变量定义 | `xref-find-definitions` |
| `C-c c R` | 查找此处函数/变量在整个项目中的所有引用 | `xref-find-references` |
| `C-c c r` | 重命名当前变量 (联动修改项目中所有的引用) | `eglot-rename` |
| `C-c c a` | 呼出当前位置的代码操作 (Code Actions 自动修复等) | `eglot-code-actions` |
| `C-c c f` | 强制格式化当前文档 | `eglot-format` |
| `C-c c e` | 在底栏打开整个项目的错误/警告诊断面板 | `flymake-show-project-diagnostics` |
| `C-c c n` | 光标跳跃到下一个代码错误位置 | `flymake-goto-next-error` |
| `C-c c p` | 光标跳跃到上一个代码错误位置 | `flymake-goto-prev-error` |

---

## 🌿 4. Git 版本控制 (Git/Magit) - 前缀 `C-c g`

| 快捷键 | 功能 | 命令 |
| :--- | :--- | :--- |
| `C-c g g` | 打开 Magit 状态总览大屏 (神器：可暂存、提交、推送) | `magit-status` |
| `C-c g c` | 开始写 Commit 提交 | `magit-commit` |
| `C-c g p` | 将代码推送到远程 Git 仓库 | `magit-push` |
| `C-c g l` | 查看当前文件的修改历史记录日志 | `magit-log-current` |

---

## 🤖 5. AI 助手与工具 (AI & Tools) - 前缀 `C-c a`

| 快捷键 | 功能 | 命令 |
| :--- | :--- | :--- |
| `C-c a c` | 启动 GPT 聊天窗口 | `gptel` |
| `C-c a s` | 在代码里选中一段内容后发送给 GPT 分析 | `gptel-send` |
| `C-c a m` | 调出 gptel 的配置面板 (修改模型、Temperature等) | `gptel-menu` |

---

## 🖵 6. 终端快捷启动 (Terminal) - 前缀 `C-c t`

| 快捷键 | 功能 | 命令 |
| :--- | :--- | :--- |
| `C-c t t` | 启动高性能的 Vterm 终端仿真器 | `vterm` |
| `C-c t s` | 在当前目录下启动 Emacs 自带的 Eshell | `eshell` |
| `C-c t p` | 在当前项目的**根目录**下启动 Eshell | `project-eshell` |

---

## 补充快捷键 (未编入 Leader Key)

除了以上的 Leader Key 逻辑，配置中还保留了一些极其常用的原生或插件快捷键：

- `C-s` : 当前文件内搜索文本 (Consult 强化版，支持实时高亮)
- `C-x b` : 强化版的 Buffer 切换 (支持模糊搜索预览)
- `M-n` / `M-p` : 除了 `C-c c n` 以外，也可以用这组按键在报错之间快速上下跳转
- `C-.` : 唤起 `embark-act`，对光标当前的词、文件、变量等对象直接执行上下文相关的快捷操作
- `<tab>` : 当 Copilot 补全代码时按下接收补全 (目前在 `init-completion.el` 中配置)
