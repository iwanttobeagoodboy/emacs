# Emacs 现代化配置使用手册

## 📖 手册概述

本手册详细介绍了基于 Emacs 30+ 的现代化 IDE 配置的使用方法、配置指南和最佳实践。该配置经过系统优化，提供了完整的开发工作流支持。

**版本**: 3.1
**最后更新**: 2026-04-25
**适用版本**: Emacs 30+
**配置状态**: ✅ 生产就绪（已修复用户报告问题）

---

## 🚀 快速开始

### 1. 系统要求

#### 必需软件
- **Emacs**: 版本 30 或更高（推荐 30.1+）
- **Git**: 版本控制工具（用于包管理）
- **curl/wget**: 网络下载工具

#### 推荐外部工具（显著提升体验）
- **ripgrep (rg)**: 高性能代码搜索工具
  ```bash
  # Ubuntu/Debian
  sudo apt install ripgrep
  
  # macOS
  brew install ripgrep
  
  # Windows (通过 scoop)
  scoop install ripgrep
  ```

- **fd-find**: 现代文件查找工具
  ```bash
  # Ubuntu/Debian
  sudo apt install fd-find
  
  # macOS  
  brew install fd
  
  # Windows
  scoop install fd
  ```

- **语言服务器**: 根据开发语言选择
  - Python: `python-lsp-server` 或 `pyright`
  - JavaScript/TypeScript: `typescript-language-server`
  - C/C++: `clangd`
  - Rust: `rust-analyzer`

### 2. 初始配置步骤

1. **备份现有配置**（如果已有）:
   ```bash
   mv ~/.emacs.d ~/.emacs.d.backup
   mv ~/.emacs ~/.emacs.backup
   ```

2. **克隆或复制配置**:
   ```bash
   # 如果使用 Git 管理
   git clone <your-repo> ~/.config/emacs
   
   # 或者直接复制文件
   cp -r /path/to/config/* ~/.config/emacs/
   ```

3. **创建本地配置文件**:
   ```bash
   cd ~/.config/emacs
   cp init-local.example.el init-local.el
   ```

4. **编辑本地配置**:
   - 打开 `init-local.el`
   - 按照注释设置个人偏好
   - 配置 API 密钥（使用环境变量或 auth-source）

5. **首次启动 Emacs**:
   ```bash
   emacs --debug-init  # 启用调试模式查看启动过程
   ```
   
   首次启动会自动安装所有包，可能需要 5-10 分钟。

### 3. 验证安装

启动 Emacs 后，运行以下命令验证配置：

```elisp
M-x my-check-search-tools    ; 检查外部工具
M-x my-check-lsp-servers     ; 检查语言服务器
M-x my-check-fonts           ; 检查系统字体
M-x my-verify-vim-config     ; 验证 Vim 模式配置
```

---

## 🏗️ 配置架构说明

### 目录结构
```
~/.config/emacs/
├── early-init.el          # 早期初始化（性能优化）
├── init.el               # 主入口文件
├── custom.el             # 自动生成的定制设置（勿手动编辑）
├── init-local.el         # 用户本地配置（个性化设置）
├── init-local.example.el # 本地配置示例
├── lisp/                  # 基础配置层
│   ├── init-basic.el      # 基础设置
│   ├── init-performance.el # 性能优化
│   ├── init-package.el     # 包管理器配置
│   ├── init-completion.el  # 补全系统
│   ├── init-search.el      # 搜索系统
│   ├── init-keybind.el     # 键位管理
│   ├── init-ui.el          # 用户界面
│   └── init-proxy.el       # 网络代理
└── modules/              # 功能模块层
    ├── mod-dev.el        # 开发环境
    ├── mod-ai.el         # AI 集成
    ├── mod-org.el        # Org 模式
    ├── mod-terminal.el   # 终端集成
    ├── mod-vim.el        # Vim模式集成（编程效率优化）
    └── mod-lang/         # 语言特定配置
```

### 配置文件说明

#### 1. `init.el` - 主配置文件
- 加载所有基础配置和模块
- 设置 custom-file 路径
- 处理本地配置加载和错误处理

#### 2. `init-local.el` - 个人配置
- **不要提交到版本控制**（已在 .gitignore 中排除）
- 包含个人 API 密钥、自定义键位、主题选择等
- 基于 `init-local.example.el` 创建

#### 3. `early-init.el` - 早期初始化
- 在 GUI 初始化前执行
- 优化启动性能
- 设置垃圾回收参数

---

## ⌨️ 快捷键速查表

### 全局前缀键
所有用户自定义快捷键均以 `SPC` (空格键) 作为全局 leader 键，采用 Spacemacs 风格。

> **提示**: 按下 `SPC` 后等待 0.3 秒，which-key 插件会自动显示所有可用快捷键。在插入模式下使用 `C-SPC` 触发 leader 键。

### 📂 1. 文件与基础操作

| 快捷键 | 功能 | 命令 |
|--------|------|------|
| `SPC f f` | 打开文件 | `find-file` |
| `SPC f s` | 保存当前文件 | `save-buffer` |
| `SPC f r` | 打开最近文件 | `recentf-open-files` |
| `SPC b b` | 切换 Buffer | `switch-to-buffer` |
| `SPC b k` | 关闭当前 Buffer | `kill-buffer` |
| `SPC b r` | 重新加载当前文件 | `revert-buffer` |
| `SPC b n` | 下一个缓冲区 | `next-buffer` |
| `SPC b p` | 上一个缓冲区 | `previous-buffer` |
| `SPC w v` | 垂直分割窗口 | `split-window-right` |
| `SPC w s` | 水平分割窗口 | `split-window-below` |
| `SPC w d` | 删除当前窗口 | `delete-window` |
| `SPC w D` | 最大化当前窗口 | `delete-other-windows` |
| `SPC w o` | 切换窗口 | `other-window` |
| `SPC w =` | 平衡窗口大小 | `balance-windows` |

### 📦 2. 项目管理

| 快捷键 | 功能 | 命令 |
|--------|------|------|
| `SPC p f` | 项目中搜索文件 | `project-find-file` |
| `SPC p p` | 切换项目 | `project-switch-project` |
| `SPC p s` | 项目内容搜索 | `project-search` |
| `SPC p c` | 编译当前项目 | `project-compile` |
| `SPC p k` | 关闭项目缓冲区 | `project-kill-buffers` |
| `SPC p d` | 项目文件管理器 | `project-dired` |

### 💻 3. 代码开发与 LSP

| 快捷键 | 功能 | 命令 |
|--------|------|------|
| `SPC c d` | 跳转到定义 | `xref-find-definitions` |
| `SPC c D` | 新窗口跳转定义 | `xref-find-definitions-other-window` |
| `SPC c R` | 查找所有引用 | `xref-find-references` |
| `SPC c r` | 重命名变量 | `eglot-rename` |
| `SPC c a` | 代码操作菜单 | `eglot-code-actions` |
| `SPC c f` | 格式化文档 | `eglot-format` |
| `SPC c e` | 显示项目诊断 | `flymake-show-project-diagnostics` |
| `SPC c n` | 下一个错误 | `flymake-goto-next-error` |
| `SPC c p` | 上一个错误 | `flymake-goto-prev-error` |

### 🌿 4. Git 版本控制

| 快捷键 | 功能 | 命令 |
|--------|------|------|
| `SPC g g` | Magit 状态总览 | `magit-status` |
| `SPC g c` | 提交更改 | `magit-commit` |
| `SPC g p` | 推送到远程 | `magit-push` |
| `SPC g l` | 查看文件历史 | `magit-log-current` |

### ⌨️ 5. Vim模式（编程效率优化）

Vim模式集成提供了在Emacs中使用Vim键绑定的能力，特别适合习惯Vim编辑器的用户。本配置采用**混合模式策略**：在编程编辑时使用Vim键绑定，在其他操作中保持Emacs键绑定。

#### 5.1 概述
Vim模式在编程缓冲区中自动启用，提供高效的文本编辑体验。使用 `i` 进入插入模式编辑代码，`ESC` 或 `jk` 返回Normal模式进行导航和操作。

#### 5.2 启用与禁用
- **自动启用**：在编程模式（prog-mode）和文本模式（text-mode）中自动启用Vim模式
- **手动切换**：使用 `SPC T v` 切换Vim模式开关（也可使用 `C-c v` 作为备用）
- **状态显示**：模式行显示当前状态（NORMAL/INSERT/VISUAL）

#### 5.3 模式切换
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `SPC T v` | 切换Vim模式 | 全局启用/禁用Vim模式 |
| `C-c v` | 切换Vim模式（备用） | 全局启用/禁用Vim模式 |
| `i` | 进入插入模式 | 在光标前插入 |
| `a` | 进入插入模式 | 在光标后插入 |
| `ESC` 或 `jk` | 退出插入模式 | 返回Normal模式 |

#### 5.4 基本Vim命令参考
| 命令 | 功能 | 说明 |
|------|------|------|
| `h` `j` `k` `l` | 移动光标 | 左/下/上/右 |
| `w` `b` | 单词移动 | 下一个/上一个单词 |
| `0` `$` | 行首/行尾 |  |
| `gg` `G` | 文件首/尾 |  |
| `dd` | 删除当前行 |  |
| `yy` | 复制当前行 |  |
| `p` | 粘贴 |  |
| `u` | 撤销 |  |
| `C-r` | 重做 |  |
| `v` | 进入Visual模式 | 字符选择 |
| `V` | 进入Visual行模式 | 行选择 |
| `C-v` | 进入Visual块模式 | 块选择 |

#### 5.5 与Emacs功能集成

##### 5.5.1 LSP集成
在Vim模式下，原有的LSP快捷键仍然可用：
- `SPC c d`：跳转到定义
- `SPC c R`：查找引用
- `SPC c r`：重命名
- `SPC c a`：代码操作

##### 5.5.2 补全系统
- 插入模式下自动触发补全
- 使用 `C-n` / `C-p` 导航补全项
- 使用 `TAB` 或 `RET` 确认补全

##### 5.5.3 项目管理
- `SPC p f`：项目文件查找
- `SPC p p`：项目切换
- `SPC p s`：项目搜索

##### 5.5.4 其他Emacs功能
在Vim模式下，原有的Emacs功能快捷键仍然可用：
- `C-c` 前缀命令（项目管理、LSP等）
- `C-x` 窗口和缓冲区操作
- `C-/` 撤销，`C-?` 重做
- `C-h` 帮助系统

#### 5.6 特殊模式处理
以下模式保持Emacs键绑定：
- **Magit**：Git仓库管理
- **Dired**：文件管理器
- **Eshell**：终端模拟器
- **Org模式**：文档编辑

#### 5.7 自定义配置
如需自定义Vim模式配置，可编辑 `modules/mod-vim.el` 文件：

```elisp
;; 修改快速退出键序列
(setq evil-escape-key-sequence "fd")

;; 添加排除模式
(add-to-list 'evil-emacs-state-modes 'special-mode)

;; 自定义键绑定
(evil-define-key 'normal 'global
  (kbd "SPC") 'my-custom-command)
```

#### 5.8 故障排除

##### 问题1：键绑定冲突
**症状**：某些命令无法执行或执行错误命令
**解决**：
1. 检查当前模式：使用 `SPC T v` 或 `C-c v` 切换模式
2. 查看键绑定：`C-h k` 后按冲突键
3. 调整配置：修改 `mod-vim.el` 中的键绑定

##### 问题2：性能下降
**症状**：启动变慢或编辑卡顿
**解决**：
1. 禁用延迟加载功能
2. 减少evil-collection加载的模式
3. 使用 `M-x my-verify-vim-config` 检查配置

##### 问题3：模式切换异常
**症状**：无法进入或退出特定模式
**解决**：
1. 检查模式排除列表
2. 验证hook配置
3. 重启Emacs

#### 5.9 验证命令
使用以下命令验证Vim模式配置：
```elisp
M-x my-verify-vim-config    ; 验证Vim配置
M-x my-toggle-vim-mode      ; 切换Vim模式
```

### 🤖 6. AI 助手

| 快捷键 | 功能 | 命令 |
|--------|------|------|
| `SPC a c` | 启动 GPT 聊天 | `gptel` |
| `SPC a s` | 发送消息 | `gptel-send` |
| `SPC a m` | GPT 配置面板 | `gptel-menu` |
| `SPC a r` | AI 代码审查 | `my-ai-code-review` |
| `SPC a e` | 解释选中代码 | `my-ai-explain-code` |
| `SPC a d` | 生成文档字符串 | `my-ai-generate-docstring` |
| `C-c a r` | AI 代码审查 (gptel-minor-mode) | `my-ai-code-review` |
| `C-c a e` | 解释选中代码 (gptel-minor-mode) | `my-ai-explain-code` |
| `C-c a d` | 生成文档 (gptel-minor-mode) | `my-ai-generate-docstring` |

### 📝 7. Org 模式

| 快捷键 | 功能 | 命令 |
|--------|------|------|
| `SPC o c` | 捕获任务/笔记 | `org-capture` |
| `SPC o a` | 打开日程表 | `org-agenda` |
| `SPC o f` | Org-roam 查找节点 | `org-roam-node-find` |
| `SPC o i` | Org-roam 插入链接 | `org-roam-node-insert` |
| `SPC o h` | 发布到 Hugo | `my-org-publish-hugo` |
| `SPC o v` | 导出为 Reveal.js | `my-org-export-reveal` |
| `SPC o t` | 待办事项列表 | `org-todo-list` |
| `C-c n f` | Org-roam 查找节点 | `org-roam-node-find` |
| `C-c n i` | Org-roam 插入节点 | `org-roam-node-insert` |
| `C-c n j` | 今日日记 | `org-roam-dailies-capture-today` |

### 🖵 8. 终端

| 快捷键 | 功能 | 命令 |
|--------|------|------|
| `SPC t s` | 启动 Eshell | `eshell` |
| `SPC t e` | 启动 Shell | `shell` |
| `SPC t p` | 项目根目录启动 Eshell | `project-eshell` |

### 🆘 9. 帮助系统

| 快捷键 | 功能 | 命令 |
|--------|------|------|
| `SPC h k` | 显示键位帮助 | `my-describe-keybindings` |
| `SPC h f` | 查看函数文档 | `describe-function` |
| `SPC h v` | 查看变量文档 | `describe-variable` |
| `SPC h b` | 显示所有键位绑定 | `describe-bindings` |
| `SPC h m` | 显示当前模式帮助 | `describe-mode` |
| `SPC h t c` | 检查 Tree-sitter | `my-check-treesitter-grammars` |
| `SPC h t l` | 检查 LSP 服务器 | `my-check-lsp-servers` |
| `SPC h t s` | 检查搜索工具 | `my-check-search-tools` |
| `SPC h t p` | 检查代理配置 | `my-check-proxy-config` |
| `SPC h t f` | 检查系统字体 | `my-check-fonts` |

### 补充快捷键（无前缀）

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `C-s` | 文件内搜索 | Consult 强化版，实时高亮 |
| `C-x b` | 切换 Buffer | 支持模糊搜索预览 |
| `C-x g` | Magit 状态 | Git 版本控制总览 |
| `M-n` / `M-p` | 错误导航 | 在诊断错误间跳转 |
| `C-.` | 上下文动作 | 对当前对象执行相关操作 |
| `C-c p x` | 切换代理开关 | `proxy-toggle` |
| `C-c p e` | 启用代理 | `proxy-enable` |
| `C-c p d` | 禁用代理 | `proxy-disable` |
| `C-c v` | 切换 Vim 模式 | `my-toggle-vim-mode` |

---

## 🔧 功能模块详解

### 补全系统 (Completion)
- **前端**: corfu（弹出式补全界面）
- **后端**: cape（多源补全：dabbrev, file, dict, symbol, history, keyword 等）
- **使用技巧**:
  - 输入时自动触发补全
  - `TAB` 选择补全项
  - `M-n`/`M-p` 在补全项间导航
  - `M-x my-describe-completion-backends` 查看所有可用补全源

### 搜索系统 (Search)
- **界面**: vertico（垂直选择器）
- **引擎**: consult（统一搜索接口）
- **匹配**: orderless（灵活模式匹配）
- **外部工具**: ripgrep (rg) + fd
- **搜索类型**:
  - `C-s`: 文件内搜索 (`consult-line`)
  - `SPC s g`: 项目内容搜索 (`consult-ripgrep`)
  - `SPC s f`: 文件查找 (`find-file`)
  - `SPC s b`: 缓冲区搜索 (`consult-buffer`)
  - `SPC s i`: 符号搜索 (`consult-imenu`)

### LSP 集成
- **客户端**: eglot（轻量级）
- **增强**: eglot-booster（自动安装服务器）
- **支持语言**: 自动检测并配置
- **功能**:
  - 代码补全
  - 定义跳转
  - 引用查找
  - 重命名重构
  - 代码格式化
  - 诊断显示

### AI 集成
- **对话式 AI**: gptel（支持多种模型，需配置 API Key）
- **辅助功能**:
  - 代码审查和建议 (`my-ai-code-review`)
  - 代码解释 (`my-ai-explain-code`)
  - 文档生成 (`my-ai-generate-docstring`)

### Org 知识管理
- **笔记系统**: org-roam（双向链接）
- **任务管理**: org-agenda（GTD）
- **发布系统**: ox-hugo（博客）
- **演示工具**: ox-reveal（幻灯片）

---

## ⚡ 性能优化指南

### 启动性能
- 使用 `early-init.el` 优化早期设置
- 延迟加载非核心包
- 启用原生编译 (native-comp)

### 运行时性能
- 智能垃圾回收（64MB 高消耗阈值）
- 异步操作避免 UI 阻塞
- 使用 ripgrep/fd 替代传统搜索工具

### 监控工具
```elisp
M-x benchmark-init           ; 启动性能分析
M-x profiler-start          ; CPU 性能分析
M-x memory-usage           ; 内存使用情况
```

---

## 🛠️ 故障排除

### 常见问题

#### 1. 启动缓慢
- 检查网络连接（包下载）
- 查看 `*Messages*` 缓冲区错误
- 运行 `M-x benchmark-init` 分析瓶颈

#### 2. 功能缺失
- 验证包是否安装：`M-x list-packages`
- 检查模块是否加载：`M-x find-library`
- 查看 `*Messages*` 缓冲区中的加载信息

#### 3. 键位冲突
- 使用 `SPC h k` 查看 leader 键位帮助
- 使用 `C-h k` 查看特定键位的当前绑定
- 使用 `SPC h b` 查看所有键位绑定

#### 4. LSP 不工作
- 运行 `M-x my-check-lsp-servers`
- 确保语言服务器已安装
- 检查项目根目录是否有配置文件

### 调试模式
```elisp
;; 在 init-local.el 中添加
(setq debug-on-error t)      ; 错误时进入调试器
(setq debug-on-quit t)       ; 按 C-g 时进入调试器

;; 启动时启用调试
emacs --debug-init
```

### 获取帮助
- `C-h r`: Emacs 手册
- `C-h f`: 函数帮助
- `C-h v`: 变量帮助
- `C-h k`: 键位绑定帮助
- `C-h m`: 当前模式帮助

---

## 🔄 更新与维护

### 配置更新
1. 通过 Git 拉取最新更改
2. 重启 Emacs 自动安装新包
3. 检查 `init-local.example.el` 是否有新配置需要合并

### 包管理
- 包通过 elpaca 管理
- 自动更新：重启 Emacs 时检查更新
- 手动更新：`M-x elpaca-update-all`

### 备份策略
1. 定期备份 `init-local.el`
2. 使用 Git 管理配置仓库
3. 导出重要 Org 笔记

---

## 📚 学习资源

### 官方文档
- [Emacs Manual](https://www.gnu.org/software/emacs/manual/)
- [Emacs Lisp Reference](https://www.gnu.org/software/emacs/manual/elisp.html)

### 社区资源
- [Emacs Reddit](https://www.reddit.com/r/emacs/)
- [Emacs China](https://emacs-china.org/)
- [System Crafters](https://systemcrafters.net/)

### 视频教程
- [Emacs From Scratch](https://www.youtube.com/@SystemCrafters)
- [Emacs 入门指南](https://space.bilibili.com/324076/channel/collectiondetail?sid=480446)

---

## 📞 支持与反馈

### 问题报告
1. 在 `*Messages*` 缓冲区查看错误信息
2. 使用 `M-x toggle-debug-on-error` 启用调试
3. 提供重现步骤和错误日志

### 功能请求
1. 检查现有功能是否满足需求
2. 参考设计文档 (`emacs_ide_design.md`)
3. 在模块架构基础上扩展

### 贡献指南
1. 遵循现有的模块化架构
2. 使用 use-package 声明式配置
3. 添加相应的文档和测试

---

## 🎯 最佳实践

### 日常工作流
1. **启动**: 直接打开项目文件或目录
2. **导航**: 使用项目搜索和文件跳转
3. **编辑**: 利用 LSP 补全和 AI 辅助
4. **版本控制**: 集成 Git 提交和推送
5. **知识管理**: 随时记录到 Org 笔记

### 配置管理
1. 将个人配置保存在 `init-local.el`
2. 使用环境变量管理敏感信息
3. 定期更新和测试配置

### 性能保持
1. 监控启动时间
2. 清理不需要的包
3. 使用性能分析工具定期检查

---

**手册更新记录**:
- 2026-04-17: 创建完整使用手册，整合优化后的配置信息
- 基于 `KEYBINDINGS.md` 升级为全面使用指南

**配置状态**: ✅ 所有优化已完成，生产环境就绪