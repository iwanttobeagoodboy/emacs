;;; mod-prog.el --- 现代编程环境 (LSP, Corfu, Tree-sitter) -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 1. Corfu: 现代弹出式补全前端 (极简、原生)
;; ──────────────────────────────────────────────────────
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-quit-no-match 'separator)
  (corfu-preview-current nil)
  :init
  (global-corfu-mode)
  :config
  (corfu-popupinfo-mode)
  (setq corfu-popupinfo-delay '(0.5 . 0.2)))

;; ──────────────────────────────────────────────────────
;; 2. Tree-sitter: 新一代精准语法高亮 (Emacs 30 核心特性)
;; ──────────────────────────────────────────────────────
;; 预编译 grammar 放在 ~/.config/emacs/tree-sitter/libtree-sitter-<lang>.dll
;; 以下 alist 用于 M-x treesit-install-language-grammar 一键重编译
;; 格式: (LANG URL REVISION)  — revision 是 git tag，不要加 nil
(setq treesit-language-source-alist
      '((c      . ("https://github.com/tree-sitter/tree-sitter-c"      "v0.21.3"))
        (cpp    . ("https://github.com/tree-sitter/tree-sitter-cpp"    "v0.22.3"))
        (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.21.0"))
        (cmake  . ("https://github.com/uyha/tree-sitter-cmake"         "v0.7.2"))))

(use-package treesit-auto
  :custom
  (treesit-auto-install nil)          ; 用预编译 DLL，不自动下载编译
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; CMakeLists.txt 不会被 treesit-auto 的 .cmake 规则命中，手动补上
(add-to-list 'auto-mode-alist '("CMakeLists.txt" . cmake-ts-mode))

;; ──────────────────────────────────────────────────────
;; 3. Language modes
;; ──────────────────────────────────────────────────────

;; Scala — Metals LSP 由 eglot 内置支持
(use-package scala-mode
  :mode "\\.scala\\'"
  :interpreter "scala")

;; ──────────────────────────────────────────────────────
;; 4. Eglot: 原生轻量级 LSP 客户端
;; ──────────────────────────────────────────────────────
(use-package eglot
  :ensure nil
  :defer t
  :hook ((python-base-mode   . eglot-ensure)   ; Python
         (c-ts-mode          . eglot-ensure)    ; C
         (c++-ts-mode        . eglot-ensure)    ; C++
         (cmake-ts-mode      . eglot-ensure)    ; CMake
         (scala-mode         . eglot-ensure))   ; Scala (Metals)
  :config
  ;; clangd 格式化：4空格缩进，不用 Tab（push 到最前面确保优先匹配）
  (push '((c-mode c++-mode)
          . ("clangd" "--fallback-style={BasedOnStyle: llvm, IndentWidth: 4}"))
        eglot-server-programs)
  (my-leader-def
    "c r" 'eglot-rename
    "c a" 'eglot-code-actions
    "c f" 'eglot-format-buffer
    "c d" 'eldoc
    "c q" 'eglot-reconnect))

;; ──────────────────────────────────────────────────────
;; 5. 编译与错误导航
;; ──────────────────────────────────────────────────────
(use-package flymake
  :ensure nil
  :defer t
  :config
  (my-leader-def
    "c e" 'flymake-show-buffer-diagnostics))

;; M-g n / M-g p 使用 Emacs 原生的 next-error / previous-error，
;; 它们同时兼容 compilation 输出和 flymake 诊断，无需覆盖绑定。

;; 编译输出自动向下滚动
(setq compilation-scroll-output t)
(global-set-key (kbd "<f5>") 'compile)

;; ──────────────────────────────────────────────────────
;; 6. C/C++ 代码格式化：4空格缩进 + 竖向缩进对齐线 + 空格可视化
;; ──────────────────────────────────────────────────────
(setq-default tab-width 4
              indent-tabs-mode nil)


;; 空格/Tab 可见化：用灰色 · 标记空格，» 标记 Tab
(use-package whitespace
  :ensure nil
  :hook (prog-mode-hook . whitespace-mode)
  :custom
  (whitespace-style '(face spaces space-mark)))

;; 竖向缩进对齐线 ┊，颜色跟随 whitespace-space 保持一致
(use-package highlight-indent-guides
  :hook (prog-mode-hook . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-character ?┊)
  (highlight-indent-guides-auto-enabled nil)
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-delay 0.1)
  :config
  (require 'whitespace)
  (let ((c (face-attribute 'whitespace-space :foreground nil t)))
    (set-face-foreground 'highlight-indent-guides-odd-face  c)
    (set-face-foreground 'highlight-indent-guides-even-face c)))

(provide 'mod-prog)
;;; mod-prog.el ends here
