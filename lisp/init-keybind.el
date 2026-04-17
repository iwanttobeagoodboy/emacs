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
    "tp" 'project-eshell)
  
  ;; 添加帮助快捷键
  (my-leader-def
    "h" '(:ignore t :which-key "help")
    "hk" 'my-describe-keybindings
    "hb" 'describe-bindings))

;; 键位帮助函数
(defun my-describe-keybindings ()
  "显示所有配置的快捷键"
  (interactive)
  (with-current-buffer (get-buffer-create "*快捷键帮助*")
    (erase-buffer)
    (insert "# Emacs 快捷键帮助文档\n\n")
    (insert "## 全局 Leader 键位 (C-c)\n\n")
    (insert "| 快捷键 | 功能 | 命令 |\n")
    (insert "|---------|------|------|\n")
    (insert "| C-c f f | 打开文件 | `find-file` |\n")
    (insert "| C-c f s | 保存文件 | `save-buffer` |\n")
    (insert "| C-c f r | 最近文件 | `recentf-open-files` |\n")
    (insert "| C-c b b | 切换 Buffer | `switch-to-buffer` |\n")
    (insert "| C-c b k | 关闭 Buffer | `kill-buffer` |\n")
    (insert "| C-c p f | 项目文件 | `project-find-file` |\n")
    (insert "| C-c p p | 切换项目 | `project-switch-project` |\n")
    (insert "| C-c g g | Magit 状态 | `magit-status` |\n")
    (insert "| C-c a c | GPT 聊天 | `gptel` |\n")
    (insert "| C-c t t | Vterm 终端 | `vterm` |\n\n")
    
    (insert "## 其他重要快捷键\n\n")
    (insert "| 快捷键 | 功能 | 命令 |\n")
    (insert "|---------|------|------|\n")
    (insert "| C-x g | Magit 状态 | `magit-status` |\n")
    (insert "| C-s | 搜索文本 | `consult-line` |\n")
    (insert "| C-x b | 切换 Buffer | `consult-buffer` |\n")
    (insert "| C-. | Embark 操作 | `embark-act` |\n")
    (insert "| M-n | 下一个错误 | `flymake-goto-next-error` |\n")
    (insert "| M-p | 上一个错误 | `flymake-goto-prev-error` |\n\n")
    
    (insert "## 使用提示\n\n")
    (insert "1. 按下 `C-c` 后等待 0.3 秒查看所有可用快捷键\n")
    (insert "2. 使用 `C-h k` 然后按快捷键查看具体命令\n")
    (insert "3. 使用 `C-h b` 查看当前所有键位绑定\n")
    (pop-to-buffer (current-buffer))))

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3)) ;; 略微加快 which-key 的提示速度

(provide 'init-keybind)
;;; init-keybind.el ends here