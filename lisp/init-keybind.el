;;; init-keybind.el --- Keybindings -*- lexical-binding: t -*-

;; 可以使用 general.el 或者内置的 bind-key
(use-package general
  :ensure t
  :config
  (general-create-definer my-leader-def
    :prefix "C-c"
    :non-normal-prefix "C-c")
  
  (my-leader-def
    ;; -----------------------------------------
    ;; 1. 文件与基础操作 (File & Basics)
    ;; -----------------------------------------
    "f" '(:ignore t :which-key "file")
    "ff" 'find-file
    "fs" 'save-buffer
    "fr" 'recentf-open-files
    
    "b" '(:ignore t :which-key "buffer")
    "bb" 'switch-to-buffer
    "bk" 'kill-buffer
    "br" 'revert-buffer
    
    "w" '(:ignore t :which-key "window")
    "wd" 'delete-window
    "wv" 'split-window-right
    "ws" 'split-window-below
    "wo" 'delete-other-windows

    ;; -----------------------------------------
    ;; 2. 项目管理 (Project)
    ;; -----------------------------------------
    "p" '(:ignore t :which-key "project")
    "pf" 'project-find-file
    "pp" 'project-switch-project
    "ps" 'project-search
    "pc" 'project-compile
    
    ;; -----------------------------------------
    ;; 3. 代码与 LSP 操作 (Code & LSP)
    ;; -----------------------------------------
    "c" '(:ignore t :which-key "code")
    "cr" 'eglot-rename
    "ca" 'eglot-code-actions
    "cf" 'eglot-format
    "cd" 'xref-find-definitions
    "cR" 'xref-find-references
    "ce" 'flymake-show-project-diagnostics
    "cn" 'flymake-goto-next-error
    "cp" 'flymake-goto-prev-error
    
    ;; -----------------------------------------
    ;; 4. Git 版本控制 (Git/Magit)
    ;; -----------------------------------------
    "g" '(:ignore t :which-key "git")
    "gg" 'magit-status
    "gc" 'magit-commit
    "gp" 'magit-push
    "gl" 'magit-log-current
    
    ;; -----------------------------------------
    ;; 5. AI 与其他工具 (AI & Tools)
    ;; -----------------------------------------
    "a" '(:ignore t :which-key "ai")
    "ac" 'gptel
    "as" 'gptel-send
    "am" 'gptel-menu
    
    ;; 快捷启动终端
    "t" '(:ignore t :which-key "terminal")
    "tt" 'vterm
    "ts" 'eshell
    "tp" 'project-eshell))

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3)) ;; 略微加快 which-key 的提示速度

(provide 'init-keybind)
;;; init-keybind.el ends here