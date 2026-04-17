;;; init-search.el --- Search and Minibuffer -*- lexical-binding: t -*-

;; Vertico: 垂直 Minibuffer
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  (setq vertico-cycle t))

;; Orderless: 无序模糊匹配
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; Consult: 增强搜索
(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("C-c r" . consult-recent-file))
  :config
  ;; 配置 ripgrep 作为搜索后端
  (setq consult-ripgrep-args
        "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --line-number --hidden -g !.git/ .")
  
  ;; 配置 fd 作为文件查找后端
  (setq consult-find-args
        "fd --color=never --full-path --hidden --exclude .git")
  
  ;; 配置 consult-grep 命令
  (setq consult-grep-command
        "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --line-number --hidden -g !.git/ ."))

;; Marginalia: Minibuffer 注释
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; Embark: Minibuffer 操作
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; 文件搜索工具检测和配置
(defun my-check-search-tools ()
  "检查系统是否安装了 ripgrep 和 fd 工具"
  (interactive)
  (let ((missing-tools '()))
    (unless (executable-find "rg")
      (push "ripgrep (rg)" missing-tools))
    (unless (executable-find "fd")
      (push "fd" missing-tools))
    (when missing-tools
      (message "警告: 以下搜索工具未安装: %s" (string-join missing-tools ", ")))))

(add-hook 'emacs-startup-hook 'my-check-search-tools)

(provide 'init-search)
;;; init-search.el ends here