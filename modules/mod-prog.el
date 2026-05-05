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
  (corfu-history-mode)
  (setq corfu-popupinfo-delay '(0.5 . 0.2))
  ;; TAB 释放给 yasnippet，corfu 用 RET 选中
  (keymap-set corfu-map "TAB" nil)
  ;; 提升补全弹窗对比度（doom-gruvbox 默认 corfu 配色偏暗）
  (set-face-attribute 'corfu-default nil :background "#3c3836" :foreground "#ebdbb2")
  (set-face-attribute 'corfu-current nil :background "#504945" :foreground "#fabd2f" :weight 'semi-bold)
  (set-face-attribute 'corfu-bar nil :background "#504945")
  (set-face-attribute 'corfu-border nil :foreground "#665c54"))

;; ──────────────────────────────────────────────────────
;; 1.5 Yasnippet: 代码片段引擎
;; ──────────────────────────────────────────────────────
(use-package yasnippet
  :hook (prog-mode-hook . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet
  :config (yasnippet-snippets-initialize))

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
  ;; --fallback-style 只接受预定义样式名 (LLVM/Google 等)，不接受内联样式
  ;; 所以格式化配置交给 .clang-format 文件处理，这里只启动 clangd
  (let ((entry (cl-find-if
                (lambda (e) (and (consp (car e)) (memq 'c-ts-mode (car e))))
                eglot-server-programs)))
    (when entry
      (setcdr entry '("clangd"))))
  (my-leader-def
    "c d" 'xref-find-definitions
    "c i" 'xref-find-implementations
    "c r" 'eglot-rename
    "c a" 'eglot-code-actions
    "c f" 'eglot-format-buffer
    "c h" 'eldoc
    "c q" 'eglot-reconnect)
  ;; 跳回：M-, (xref-pop-marker-stack) 为 Emacs 原生绑定，无需额外设置
  )

;; ──────────────────────────────────────────────────────
;; 4.5 Dap: 调试支持 (eglot 桥接)
;; ──────────────────────────────────────────────────────
(use-package dap-mode
  :after eglot
  :config
  (dap-ui-mode)
  (dap-ui-controls-mode)
  (require 'dap-eglot)
  (require 'dap-cpptools)
  (require 'dap-python)
  (setq dap-python-executable (or (executable-find "python3")
                                  (executable-find "python")
                                  "python"))
  (dap-register-debug-template
   "C/C++ Debug (cpptools)"
   (list :type "cpptools"
         :request "launch"
         :program "${workspaceFolder}/${fileBasenameNoExtension}"
         :cwd "${workspaceFolder}"))
  (dap-register-debug-template
   "Python Debug (debugpy)"
   (list :type "python"
         :request "launch"
         :program "${file}"
         :cwd "${workspaceFolder}"))
  (my-leader-def
    "d d" 'dap-debug
    "d l" 'dap-debug-last
    "d b" 'dap-breakpoint-toggle
    "d B" 'dap-breakpoint-list
    "d n" 'dap-next
    "d s" 'dap-step-in
    "d o" 'dap-step-out
    "d c" 'dap-continue
    "d r" 'dap-restart-frame
    "d q" 'dap-disconnect
    "d u" 'dap-ui-mode))

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
(setq whitespace-action '(auto-cleanup))

;; Tree-sitter 模式各自的缩进偏移量
(setq c-ts-mode-indent-offset 4)
(setq c-ts-mode-indent-style 'bsd)
(setq cmake-ts-mode-indent-offset 4)

;; yank 时临时禁用 electric-indent，防止首行多出一级缩进
(dolist (cmd '(yank yank-pop))
  (advice-add cmd :around
              (lambda (orig-fn &rest args)
                (let ((electric-indent-inhibit t))
                  (apply orig-fn args)))))

;; 自动配对括号 + 输入右括号时跳过已有配对符 (仅在编程模式)
(add-hook 'prog-mode-hook 'electric-pair-mode)


;; 空格/Tab 可见化：用灰色 · 标记空格，» 标记 Tab
;; indent-tabs-mode 为 nil 时任何 Tab 都是错误，必须可见
(use-package whitespace
  :ensure nil
  :hook (prog-mode-hook . whitespace-mode)
  :custom
  (whitespace-style '(face spaces tabs space-mark tab-mark)))

;; 竖向缩进对齐线 ┊，颜色跟随 whitespace-space 保持一致
;; character 方法用的是 character-face（不是 odd/even-face），
;; responsive='top 时用 top-character-face
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
  (defun my/indent-guides-sync-color (&rest _)
    "将缩进参考线颜色同步为 whitespace-space 的前景色。"
    (let ((c (face-attribute 'whitespace-space :foreground)))
      (when (and c (not (eq c 'unspecified)))
        (set-face-foreground 'highlight-indent-guides-character-face c)
        (set-face-foreground 'highlight-indent-guides-top-character-face c)
        (set-face-foreground 'highlight-indent-guides-stack-character-face c))))
  ;; 首次加载 + 每次打开 prog 缓冲区 + 切换主题时都同步颜色
  (my/indent-guides-sync-color)
  (add-hook 'prog-mode-hook #'my/indent-guides-sync-color 99)
  (advice-add 'enable-theme :after #'my/indent-guides-sync-color))

;; ──────────────────────────────────────────────────────
;; 7. 行 / 区域上下移动
;; ──────────────────────────────────────────────────────
(defun my/move-line-up ()
  "上移当前行或选中区域一行。"
  (interactive)
  (if (use-region-p)
      (let ((beg (region-beginning)) (end (copy-marker (region-end))))
        (goto-char beg)
        (unless (bolp) (beginning-of-line))
        (when (bobp) (user-error "Already at top"))
        (let ((text (delete-and-extract-region (point) end)))
          (forward-line -1)
          (insert text)
          (set-mark (point))
          (goto-char (copy-marker (point) (length text)))))
    (transpose-lines 1)
    (forward-line -2)))

(defun my/move-line-down ()
  "下移当前行或选中区域一行。"
  (interactive)
  (if (use-region-p)
      (let ((beg (copy-marker (region-beginning))) (end (region-end)))
        (goto-char end)
        (unless (bolp) (beginning-of-line 2))
        (when (eobp) (user-error "Already at bottom"))
        (let ((text (delete-and-extract-region beg (point))))
          (forward-line 1)
          (insert text)
          (set-mark (- (point) (length text)))
          (goto-char (point))))
    (forward-line 1)
    (transpose-lines 1)
    (forward-line -1)))

(global-set-key (kbd "M-k")   #'my/move-line-up)
(global-set-key (kbd "M-j") #'my/move-line-down)

(provide 'mod-prog)
;;; mod-prog.el ends here
