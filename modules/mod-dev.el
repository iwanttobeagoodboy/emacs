;;; mod-dev.el --- General Development Environment -*- lexical-binding: t -*-

;; 基础 LSP 客户端: Eglot
(use-package eglot
  :ensure nil
  :hook ((prog-mode . eglot-ensure))
  :config
  (setq eglot-autoshutdown t
        eglot-extend-to-xref t
        eglot-events-buffer-size 0)  ;; 禁用事件缓冲区
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "--stdio")))
  ;; 自动设置 Eglot 对 Clangd 的默认初始化选项，解决 Windows 下 clangd 默认走 MSVC 导致找不到 MinGW <iostream> 的 Bug
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((c-mode c++-mode c-ts-mode c++-ts-mode) .
                   ("clangd" "--query-driver=**/*" "--compile-commands-dir=.")))
    
    (setq-default eglot-workspace-configuration
                  '((:clangd . (:fallbackFlags ["-std=c++17" "--target=x86_64-w64-mingw32"]))))))

;; Eglot 性能优化
;; 暂时注释掉 eglot-booster，因为包源有问题
(use-package eglot-booster
  :elpaca (eglot-booster :host github :repo "jdtsmith/eglot-booster")
  :after eglot
  :config (eglot-booster-mode 1)
  (setq eglot-booster-auto-install-servers t))

;; (use-package eglot-booster
;;   :ensure t
;;   :after eglot
;;   :config
;;   (eglot-booster-mode)
;;   (setq eglot-booster-auto-install-servers t))

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
      (message "提示: 以下语言服务器未安装: %s" (string-join missing-servers ", "))
      (message "请手动安装相应的语言服务器"))))

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

;; 代码树级解析: Treesit
(setq treesit-extra-load-path '("~/.emacs.d/tree-sitter"))

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