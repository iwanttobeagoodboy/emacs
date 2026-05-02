# 🚀 My Emacs: The Keyboard-Driven Operating System

> "编辑器不仅仅是写代码的工具，它是思维的延伸。"

基于 **Doom Emacs 哲学** 的个人 Emacs 配置，采用"核心底座 + 业务模块"的分层架构，打造零视觉干扰、极致懒加载的心流工作台。

---

## ⌨️ 快捷键速查

按下 `C-c` 稍等 0.3 秒，`which-key` 弹出菜单提示后续按键，无需死记。

| 前缀 | 语义 | 按键 → 功能 |
|---|---|---|
| `C-c p` | **P**roject | `p` 切换 `f` 找文件 `s` 全文搜 `k` 关 buffer |
| `C-c c` | **C**ode | `r` 重命名 `a` 代码动作 `f` 格式化 `d` 文档 `e` 诊断 `q` 重启 LSP |
| `C-c n` | **N**otes | `f` 找节点 `i` 插链接 `r` 反链 `s` 全文搜 `c` 快速捕获 |
| `C-c o` | **O**pen | `a` Agenda `u` 知识图谱 |
| `C-x g` | **G**it | Magit 状态面板 |
| `<f5>` | 编译 | 运行 `compile` |
| `M-g n/p` | 错误跳转 | 下一个 / 上一个错误 |

---

## 💻 工作流 1：软件开发生命周期

### 场景 1.1：启动一天的开发——打开工程、定位文件

```
C-c p p   → 模糊搜索项目名，回车进入
C-c p f   → 模糊搜索文件名，回车打开
```

Projectile 自动识别 `.git` 目录为项目根。打开过一次的项目会被记住，下次 `C-c p p` 排在前面。

### 场景 1.2：在文件内快速浏览和定位

```
C-s       → consult-line：输入关键词，右侧窗口实时预览所有匹配行
C-x b     → consult-buffer：切换 buffer，支持按文件/最近访问过滤
```

### 场景 1.3：编写 C++ 代码——自动补全

打开 `.cpp` 文件 → eglot 自动启动 clangd → 输入 2 个字符后 corfu 弹出补全菜单：

```
输入 std::vec  → 弹出补全列表，Tab 选择，Enter 确认
光标停在函数上  → C-c c d  查看 Eldoc 函数签名和文档
```

补全和诊断需要系统安装 `clangd`（C/C++）和 `pyright`（Python）。

### 场景 1.4：重构——批量重命名变量

```
光标放在变量名上 → C-c c r → 输入新名字 → Enter
```

eglot 通过 clangd 在整个项目中替换所有引用。

### 场景 1.5：格式化代码

```
C-c c f   → eglot-format-buffer：clangd 按 4 空格缩进格式化整个文件
```

缩进规则：4 空格，不用 Tab。clangd 使用 `--fallback-style` 参数。项目有 `.clang-format` 文件时自动优先用它。

### 场景 1.6：编译与修复错误

```
<f5>      → 输入编译命令（如 make、cmake --build build）
M-g n     → 跳到下一个报错位置
M-g p     → 跳到上一个报错位置
C-c c e   → 展开当前文件的诊断面板，查看所有 LSP 报错/警告
```

编译输出自动向下滚动。`M-g n/p` 同时适用于编译错误和 flymake 诊断。

### 场景 1.7：查看改动并提交

```
C-x g     → 打开 Magit 状态面板
s         → 暂存当前文件（stage）
c c       → 提交，输入 commit message 后 C-c C-c
P p       → 推送到远程
```

在 Magit 面板按 `?` 查看完整快捷键列表。

### 场景 1.8：跨文件全文搜索

```
C-c p s   → consult-ripgrep：在项目内全文搜索
输入关键词  → 实时预览匹配行，Enter 跳转
```

依赖系统安装 `ripgrep`（`scoop install ripgrep` 或 `choco install ripgrep`）。

---

## 🗓️ 工作流 2：GTD 任务调度

### 核心文件

| 文件 | 路径 | 用途 |
|---|---|---|
| 收件箱 | `~/.config/emacs/org/inbox.org` | 所有想法的第一落脚点 |
| 待办清单 | `~/.config/emacs/org/todo.org` | 已分类的项目任务 |
| 归档目录 | `~/.config/emacs/org/archive/YYYY/MM/` | 按月自动归档已完成事项 |

任务状态流转：`IDEA → TODO → DOING → WAITING → DONE / CANCEL`

### 场景 2.1：编码时突然想到一件事——闪电捕获

```
C-c n c   → 弹出 Org-capture 窗口，与当前 buffer 无关
           输入想法内容（来源自动记录当前文件路径和时间戳）
C-c C-c   → 保存到 inbox.org，窗口自动关闭，回到刚才的代码
```

整个过程 5 秒，不打断当前工作上下文。

### 场景 2.2：每周一上午——清空收件箱、分配任务

```
C-c o a   → 打开议程面板
输入 r    → 选择"周期性复盘看板"
```

复盘看板分组显示：
- 📥 **待处理原始想法**（inbox 中 IDEA 状态）
- 🚀 **正在推进**（DOING 状态）
- ⏳ **待处理堆积**（TODO 状态）
- ⏸️ **阻塞等待**（WAITING 状态）

```
光标停在 inbox 事项上 → C-c C-w → 模糊搜索目标文件（如 todo.org 的某个标题）→ Enter
事项归类完成
```

### 场景 2.3：完成一个任务——归档

```
光标停在 DONE 事项上 → C-c C-x C-a → 自动移入 archive/2026/05/todo.org_archive
```

归档按年/月自动分层，不会弄乱主文件。

### 场景 2.4：开始做一件事——更新状态

```
光标停在 TODO 事项上 → S-RIGHT（Shift+右键头）→ 状态变为 DOING
事项做完 → S-RIGHT → 状态变为 DONE，自动记录完成时间戳
```

---

## 🧠 工作流 3：网状知识管理

### 核心理念

所有笔记存放在 `~/.config/emacs/org/roam/` 单一扁平目录下。不建文件夹、不分类——靠双向链接和全文搜索找到任何笔记。

### 场景 3.1：学习新概念——创建原子笔记

```
C-c n f   → 输入概念名（如"RAII"）→ 回车
           选择模板 "d 默认概念" → 自动生成带时间戳 ID 的文件
           开始写笔记
```

每个笔记是一个 Org 文件，自动带唯一 ID，可以被其他笔记引用。

### 场景 3.2：链接相关知识——编织知识网络

```
在笔记 A 中光标放在要插入链接的位置
C-c n i   → 模糊搜索已存在的笔记 B → Enter
           插入 [[id:xxx][笔记B标题]] 的双向链接
```

笔记 B 的反链面板会自动显示"被笔记 A 引用"。

### 场景 3.3：查看谁引用了当前笔记

```
C-c n r   → 侧边栏开关：显示当前笔记的所有反向链接
```

### 场景 3.4：记得内容但不记得标题——全文搜索

```
C-c n s   → consult-org-roam-search
输入关键词  → 实时搜索所有笔记的标题和正文
Enter      → 打开匹配的笔记
```

### 场景 3.5：可视化知识结构

```
C-c o u   → 启动 Org-roam-UI 服务 + 自动打开浏览器
           看到节点之间的网状连接图
           点击节点跳转到对应笔记
```

浏览器中视图跟随当前编辑位置自动移动（`org-roam-ui-follow t`）。

---

## 📂 目录架构

```text
~/.config/emacs/
├── early-init.el         # 启动优化：GC调优、关闭UI闪屏、首帧字体
├── init.el               # 指挥中心：加载顺序、模块路由
├── custom.el             # 自动生成的脏代码隔离区
│
├── core/                 # 核心底座
│   ├── core-packages.el  # 包源 (MELPA/ELPA) + use-package
│   ├── core-ui.el        # 主题、字体、编码、备份
│   └── core-keybinds.el  # Leader Key 骨架 (General + Which-key)
│
└── modules/              # 业务模块
    ├── mod-completion.el # Vertico + Consult + Projectile + Embark
    ├── mod-prog.el       # Corfu + Eglot + Flymake + 缩进 + 空格可视化
    ├── mod-git.el        # Magit + Diff-hl
    ├── mod-org.el        # Org Capture + Agenda + Refile + Archive
    └── mod-roam.el       # Org-roam + Consult-org-roam + Roam-UI
```

---

## 🚀 安装与启动

1. 备份原有配置：
   ```bash
   mv ~/.config/emacs ~/.config/emacs.bak
   mv ~/.emacs ~/.emacs.bak
   ```
2. 克隆本仓库：
   ```bash
   git clone <your-repo-url> ~/.config/emacs
   ```
3. 外部依赖：
   - **LSP Server**：`clangd` (C/C++)、`pyright` (Python)、`metals` (Scala)
   - **ripgrep**：Consult 全文搜索（`scoop install ripgrep`）
   - **JetBrains Mono NF**：Nerd Font 字体（`scoop install JetBrainsMono-NF`）
4. 启动 Emacs，首次自动从 MELPA 下载并编译所有插件。
```
