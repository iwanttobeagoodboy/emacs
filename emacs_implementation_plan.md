# Emacs 30+ IDE 架构配置落地实施方案

基于现代化、高性能、内建优先的设计原则，本指南将架构方案转化为可执行的配置实施步骤。

整体实施遵循： - 先基座后业务 - 先性能后功能

------------------------------------------------------------------------

## 一、配置组织架构规划

### 1. 目录结构设计

    ~/.emacs.d/
    ├── early-init.el
    ├── init.el
    ├── lisp/
    │   ├── init-package.el
    │   ├── init-basic.el
    │   ├── init-ui.el
    │   ├── init-completion.el
    │   ├── init-search.el
    │   ├── init-keybind.el
    │   └── init-performance.el
    └── modules/
        ├── mod-dev.el
        ├── mod-ai.el
        ├── mod-org.el
        ├── mod-terminal.el
        └── mod-lang/
            ├── lang-python.el
            ├── lang-cc.el
            └── lang-elisp.el

------------------------------------------------------------------------

### 2. 包管理器初始化策略

使用 elpaca + use-package：

``` elisp
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(setq use-package-always-ensure t)
```

------------------------------------------------------------------------

## 二、分阶段实施

------------------------------------------------------------------------

### Phase 1：基础设施与性能

-   early-init.el：
    -   提高 GC 阈值
    -   关闭 UI 元素
    -   开启 native-comp
-   性能优化：
    -   gcmh
    -   垃圾回收调优
-   UI：
    -   doom-themes / modus-themes
    -   doom-modeline
    -   nerd-icons

------------------------------------------------------------------------

### Phase 2：补全与交互

-   vertico + orderless + consult
-   marginalia + embark
-   corfu + cape
-   copilot.el（手动触发）

------------------------------------------------------------------------

### Phase 3：开发环境

-   treesit + combobulate
-   eglot + flymake
-   apheleia（格式化）
-   project.el + xref

------------------------------------------------------------------------

### Phase 4：AI 集成

-   gptel
-   transient AI 面板
-   自动上下文注入

------------------------------------------------------------------------

### Phase 5：Org GTD 系统

-   org-capture
-   org-agenda + org-super-agenda
-   org-roam + org-journal
-   org-noter

------------------------------------------------------------------------

### Phase 6：终端与调试

-   eat / vterm
-   dape（调试）
-   多语言支持（Python / C++）

------------------------------------------------------------------------

## 总结

该实施方案确保：

-   架构清晰
-   可扩展
-   高性能
-   可长期维护
