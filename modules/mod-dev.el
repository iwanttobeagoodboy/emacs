;;; mod-dev.el --- General Development Environment -*- lexical-binding: t -*-

;; 基础 LSP 客户端: Eglot
(use-package eglot
  :ensure nil
  :hook ((prog-mode . eglot-ensure))
  :config
  (setq eglot-autoshutdown t
        eglot-extend-to-xref t
        eglot-events-buffer-size 0)  ;; 禁用事件缓冲区
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "--stdio"))))

;; Eglot 性能优化
;; 暂时注释掉 eglot-booster，因为包源有问题
(use-package eglot-booster
  :elpaca (eglot-booster :host github :repo "jdtsmith/eglot-booster")
  :after eglot
  :config (eglot-booster-mode 1)
  (setq eglot-booster-auto-install-servers t))

;; 语言服务器管理
(defun my-check-lsp-servers ()
  "检查常用语言服务器是否已安装"
  (interactive)
  (let ((missing-servers '()))
    (unless (executable-find "pyright")
      (push "pyright (Python)" missing-servers))
    (unless (executable-find "clangd")
      (push "clangd (C/C++)" missing-servers))
    (unless (executable-find "rust-analyzer")
      (push "rust-analyzer (Rust)" missing-servers))
    (unless (executable-find "typescript-language-server")
      (push "typescript-language-server (TypeScript/JavaScript)" missing-servers))
    
    (when missing-servers
      (message "提示: 以下语言服务器未安装: %s" (string-join missing-servers ", ")))))

(add-hook 'emacs-startup-hook 'my-check-lsp-servers)

;; 语法检查: Flymake
(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :bind (("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))
(setq eglot-ignored-server-capabilities '(:hoverProvider))

;; 项目管理: Project.el
(use-package project
  :ensure nil
  :bind (("C-x p f" . project-find-file)
         ("C-x p p" . project-switch-project)
         ("C-x p s" . project-search)))

;; ----------------------------------------------------------------------------
;; Tree-sitter 语法解析系统
;; ----------------------------------------------------------------------------

;; 自动安装和管理 Tree-sitter 语法
(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install 'prompt)  ; 'prompt, 't, or 'nil
  (setq treesit-auto-add-to-auto-mode-alist 'all)  ; 'all, 'some, or 'none
  
  ;; 配置要安装的语法
  (setq treesit-auto-langs '(bash c cpp css dockerfile go html java javascript json jsx make python rust toml tsx typescript yaml))
  
  ;; 启用全局模式
  (global-treesit-auto-mode))

;; Tree-sitter 额外加载路径
(setq treesit-extra-load-path '("~/.emacs.d/tree-sitter" "~/.config/emacs/tree-sitter"))

;; Tree-sitter 语法检查函数
(defun my-check-treesitter-grammars ()
  "检查 Tree-sitter 语法安装状态。"
  (interactive)
  (let ((missing-grammars '())
        (installed-grammars '()))
    
    ;; 检查常用语法
    (dolist (lang '(bash c cpp css go html java javascript json python rust typescript yaml))
      (let ((grammar-symbol (intern (format "%s-ts-mode" lang))))
        (if (treesit-language-available-p lang)
            (push (symbol-name grammar-symbol) installed-grammars)
          (push (symbol-name grammar-symbol) missing-grammars))))
    
    ;; 显示结果
    (if (or missing-grammars installed-grammars)
        (progn
          (when installed-grammars
            (message "✅ 已安装语法: %s" (string-join installed-grammars ", ")))
          (when missing-grammars
            (message "⚠️  缺失语法: %s" (string-join missing-grammars ", "))
            (message "使用 M-x treesit-auto-install-all 安装所有缺失语法")))
      (message "未配置 Tree-sitter 语法检查"))))

;; 自动切换到 Tree-sitter 模式
(defun my-auto-enable-treesit ()
  "自动启用 Tree-sitter 模式（如果可用）。"
  (when (and (fboundp 'treesit-available-p)
             (treesit-available-p))
    (pcase major-mode
      ('c-mode (when (treesit-language-available-p 'c)
                 (c-ts-mode)))
      ('c++-mode (when (treesit-language-available-p 'cpp)
                   (c++-ts-mode)))
      ('python-mode (when (treesit-language-available-p 'python)
                      (python-ts-mode)))
      ('js-mode (when (treesit-language-available-p 'javascript)
                  (js-ts-mode)))
      ('typescript-mode (when (treesit-language-available-p 'typescript)
                          (typescript-ts-mode)))
      ('json-mode (when (treesit-language-available-p 'json)
                    (json-ts-mode)))
      ('yaml-mode (when (treesit-language-available-p 'yaml)
                    (yaml-ts-mode)))
      ('rust-mode (when (treesit-language-available-p 'rust)
                    (rust-ts-mode)))
      ('go-mode (when (treesit-language-available-p 'go)
                  (go-ts-mode))))))

;; 为支持的语言添加 hook
(add-hook 'c-mode-hook 'my-auto-enable-treesit)
(add-hook 'c++-mode-hook 'my-auto-enable-treesit)
(add-hook 'python-mode-hook 'my-auto-enable-treesit)
(add-hook 'js-mode-hook 'my-auto-enable-treesit)
(add-hook 'typescript-mode-hook 'my-auto-enable-treesit)
(add-hook 'json-mode-hook 'my-auto-enable-treesit)
(add-hook 'yaml-mode-hook 'my-auto-enable-treesit)
(add-hook 'rust-mode-hook 'my-auto-enable-treesit)
(add-hook 'go-mode-hook 'my-auto-enable-treesit)

;; Tree-sitter 字体锁定增强
(setq treesit-font-lock-level 4)  ; 最大语法高亮级别

;; 自动格式化: Apheleia
(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1)
  ;; 修改 clang-format 的默认回退风格，使其默认使用大括号换行 (Allman) 并且缩进为4
  ;; 这样在项目没有 .clang-format 文件时，保存文件也会自动格式化为大括号换行
  (setf (alist-get 'clang-format apheleia-formatters)
        '("clang-format" "-assume-filename"
          (or (buffer-file-name) (buffer-name))
          "--fallback-style={BasedOnStyle: LLVM, BreakBeforeBraces: Allman, IndentWidth: 4}")))

;; Git 集成: Magit
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :config
  (with-eval-after-load 'magit
    ;; 确保 Magit 内部键位不被全局键位覆盖
    (define-key magit-status-mode-map (kbd "C-c g") nil)))

;; 版本控制显示边缘: Diff-hl
(use-package diff-hl
  :ensure t
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :init
  (global-diff-hl-mode)
  (diff-hl-margin-mode))

(provide 'mod-dev)
;;; mod-dev.el ends here