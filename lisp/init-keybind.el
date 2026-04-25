;;; init-keybind.el --- Keybindings with M-SPC as leader key -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------------
;; Leader 键配置: 使用 M-SPC (Alt+空格) 作为全局 leader 键
;; 避免与 SPC（空格）的 self-insert-command 和 evil-mode 冲突
;;
;; 注意: M-SPC 在 global-map 中默认被绑定为 self-insert-command，
;; 因此必须使用 general-override-mode-map (override) 来设置前缀键，
;; 避免 "Key sequence starts with non-prefix key" 错误。
;; ----------------------------------------------------------------------------

;; 使用 general.el 进行键位管理
(use-package general
  :ensure t
  :config
  (general-override-mode 1)
  (setq general-override-states nil)

  ;; 在 global-map 中解除 M-SPC 的默认绑定 (self-insert-command)
  ;; 否则 general.el 无法将其设为前缀键
  (global-unset-key (kbd "M-SPC"))

  (general-create-definer my-leader-def
    :prefix "M-SPC"
    :keymaps 'override)  ;; 使用 override map 避免与 global-map 冲突

  (general-create-definer my-local-leader-def
    :prefix ",")

  ;; --------------------------------------------------------------------------
  ;; 全局 M-SPC 快捷键 (Spacemacs 风格)
  ;; --------------------------------------------------------------------------
  (my-leader-def
    ;; M-SPC SPC: 快速执行命令
    "SPC" 'execute-extended-command

    ;; -----------------------------------------
    ;; 1. 文件与基础操作 (File & Basics) - M-SPC f
    ;; -----------------------------------------
    "f" '(:ignore t :which-key "文件")
    "f f" 'find-file
    "f s" 'save-buffer
    "f S" 'save-some-buffers
    "f r" 'recentf-open-files
    "f d" 'delete-file
    "f R" 'rename-file
    "f C" 'copy-file
    "f y" 'show-file-path
    "f e" '(:ignore t :which-key "编辑")
    "f e d" 'ediff
    "f e c" 'ediff-current-file
    
    ;; -----------------------------------------
    ;; 2. 缓冲区操作 (Buffer) - M-SPC b
    ;; -----------------------------------------
    "b" '(:ignore t :which-key "缓冲区")
    "b b" 'switch-to-buffer
    "b B" 'consult-buffer
    "b k" 'kill-buffer
    "b K" 'kill-some-buffers
    "b r" 'revert-buffer
    "b n" 'next-buffer
    "b p" 'previous-buffer
    "b s" 'save-buffer
    "b R" 'rename-buffer
    "b m" 'bookmark-set
    "b M" 'bookmark-bmenu-list
    
    ;; -----------------------------------------
    ;; 3. 窗口操作 (Window) - M-SPC w
    ;; -----------------------------------------
    "w" '(:ignore t :which-key "窗口")
    "w d" 'delete-window
    "w D" 'delete-other-windows
    "w v" 'split-window-right
    "w s" 'split-window-below
    "w h" 'windmove-left
    "w j" 'windmove-down
    "w k" 'windmove-up
    "w l" 'windmove-right
    "w o" 'other-window
    "w m" 'maximize-window
    "w =" 'balance-windows
    "w r" 'window-resize
    
    ;; -----------------------------------------
    ;; 4. 项目管理 (Project) - M-SPC p
    ;; -----------------------------------------
    "p" '(:ignore t :which-key "项目")
    "p f" 'project-find-file
    "p F" 'project-find-regexp
    "p p" 'project-switch-project
    "p s" 'project-search
    "p r" 'project-query-replace-regexp
    "p c" 'project-compile
    "p C" 'project-run
    "p k" 'project-kill-buffers
    "p a" 'project-remember-projects-under
    "p d" 'project-dired
    
    ;; -----------------------------------------
    ;; 5. 代码与 LSP 操作 (Code & LSP) - M-SPC c
    ;; -----------------------------------------
    "c" '(:ignore t :which-key "代码")
    "c r" 'eglot-rename
    "c a" 'eglot-code-actions
    "c f" 'eglot-format
    "c d" 'xref-find-definitions
    "c D" 'xref-find-definitions-other-window
    "c R" 'xref-find-references
    "c e" 'flymake-show-project-diagnostics
    "c n" 'flymake-goto-next-error
    "c p" 'flymake-goto-prev-error
    "c l" '(:ignore t :which-key "LSP")
    "c l r" 'eglot-reconnect
    "c l s" 'eglot-shutdown
    "c l S" 'eglot-shutdown-all
    "c l d" 'eglot-events-buffer
    
    ;; -----------------------------------------
    ;; 6. Git 版本控制 (Git) - M-SPC g
    ;; -----------------------------------------
    "g" '(:ignore t :which-key "Git")
    "g g" 'magit-status
    "g s" 'magit-stage-file
    "g u" 'magit-unstage-file
    "g c" 'magit-commit
    "g C" 'magit-commit-create
    "g p" 'magit-push
    "g P" 'magit-pull
    "g l" 'magit-log-current
    "g L" 'magit-log-buffer-file
    "g b" 'magit-branch
    "g B" 'magit-branch-checkout
    "g d" 'magit-diff
    "g D" 'magit-diff-unstaged
    "g r" 'magit-rebase
    
    ;; -----------------------------------------
    ;; 7. AI 助手 (AI) - M-SPC a
    ;; -----------------------------------------
    "a" '(:ignore t :which-key "AI")
    "a c" 'gptel
    "a s" 'gptel-send
    "a m" 'gptel-menu
    "a r" 'my-ai-code-review
    "a e" 'my-ai-explain-code
    "a d" 'my-ai-generate-docstring
    "a t" 'my-check-ai-config
    
    ;; -----------------------------------------
    ;; 8. Org 模式 (Org) - M-SPC o
    ;; -----------------------------------------
    "o" '(:ignore t :which-key "Org")
    "o c" 'org-capture
    "o a" 'org-agenda
    "o r" 'org-roam-node-find
    "o f" 'org-roam-node-find
    "o i" 'org-roam-node-insert
    "o h" 'my-org-publish-hugo
    "o v" 'my-org-export-reveal
    "o t" 'org-todo-list
    "o T" 'org-show-todo-tree
    
    ;; -----------------------------------------
    ;; 9. 终端 (Terminal) - M-SPC t
    ;; -----------------------------------------
    "t" '(:ignore t :which-key "终端")
    "t s" 'eshell
    "t e" 'shell
    "t p" 'project-eshell
    
    ;; -----------------------------------------
    ;; 10. 搜索 (Search) - M-SPC s
    ;; -----------------------------------------
    "s" '(:ignore t :which-key "搜索")
    "s f" 'find-file
    "s F" 'consult-find
    "s g" 'consult-ripgrep
    "s G" 'consult-git-grep
    "s l" 'consult-line
    "s L" 'consult-line-multi
    "s b" 'consult-buffer
    "s k" 'consult-yank-pop
    "s m" 'consult-man
    "s i" 'consult-imenu
    "s I" 'consult-imenu-multi
    
    ;; -----------------------------------------
    ;; 11. 帮助与工具 (Help & Tools) - M-SPC h
    ;; -----------------------------------------
    "h" '(:ignore t :which-key "帮助")
    "h k" 'my-describe-keybindings
    "h K" 'describe-key
    "h f" 'describe-function
    "h v" 'describe-variable
    "h m" 'describe-mode
    "h b" 'describe-bindings
    "h p" 'describe-package
    "h i" 'info
    "h I" 'info-emacs-manual
    "h t" '(:ignore t :which-key "工具")
    "h t c" 'my-check-treesitter-grammars
    "h t l" 'my-check-lsp-servers
    "h t s" 'my-check-search-tools
    "h t p" 'my-check-proxy-config
    "h t f" 'my-check-fonts
    
    ;; -----------------------------------------
    ;; 12. 切换与切换 (Toggle) - M-SPC t
    ;; -----------------------------------------
    "T" '(:ignore t :which-key "切换")
    "T l" 'display-line-numbers-mode
    "T w" 'whitespace-mode
    "T s" 'flyspell-mode
    "T d" 'toggle-debug-on-error
    "T v" 'my-toggle-vim-mode
    "T p" 'proxy-toggle
    "T t" 'theme-toggle
    "T f" 'toggle-frame-fullscreen)
  
  ;; --------------------------------------------------------------------------
  ;; 特定模式下的本地 leader 键
  ;; --------------------------------------------------------------------------
  (my-local-leader-def
    :keymaps 'org-mode-map
    "," '(:ignore t :which-key "Org本地")
    ",c" 'org-ctrl-c-ctrl-c
    ",e" 'org-export-dispatch
    ",t" 'org-todo
    ",d" 'org-deadline
    ",s" 'org-schedule
    ",i" 'org-insert-link
    ",I" 'org-insert-all-links)
  
  (my-local-leader-def
    :keymaps 'prog-mode-map
    "," '(:ignore t :which-key "代码本地")
    ",c" 'comment-line
    ",C" 'comment-region
    ",f" 'eglot-format
    ",r" 'eglot-rename
    ",d" 'xref-find-definitions
    ",R" 'xref-find-references))

;; ----------------------------------------------------------------------------
;; 辅助函数
;; ----------------------------------------------------------------------------

;; 键位帮助函数 - 利用 which-key 动态显示
(defun my-describe-keybindings ()
  "显示 M-SPC leader 键的可用快捷键。"
  (interactive)
  (if (fboundp 'which-key-show-top-level)
      (which-key-show-top-level)
    (describe-bindings (kbd "M-SPC"))))

;; 主题切换函数
(defun theme-toggle ()
  "切换主题。"
  (interactive)
  (if (eq (car custom-enabled-themes) 'doom-one)
      (progn
        (disable-theme 'doom-one)
        (load-theme 'doom-vibrant t)
        (message "切换到 doom-vibrant 主题"))
    (progn
      (disable-theme 'doom-vibrant)
      (load-theme 'doom-one t)
      (message "切换到 doom-one 主题"))))

;; 文件路径显示函数
(defun show-file-path ()
  "显示当前文件的完整路径。"
  (interactive)
  (message "文件路径: %s" (buffer-file-name)))

;; ----------------------------------------------------------------------------
;; Which-key 配置
;; ----------------------------------------------------------------------------

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3
        which-key-popup-type 'minibuffer
        which-key-side-window-location 'bottom
        which-key-side-window-max-width 0.33
        which-key-side-window-max-height 0.25
        which-key-max-description-length 40
        which-key-sort-order 'which-key-key-order-alpha
        which-key-use-C-h-commands nil)
  
  ;; 为 M-SPC 添加特殊处理
  (which-key-add-key-based-replacements
    "M-SPC" "全局 leader 键"
    "M-SPC SPC" "M-x: 执行命令"
    "M-SPC f" "文件操作"
    "M-SPC b" "缓冲区操作"
    "M-SPC w" "窗口操作"
    "M-SPC p" "项目管理"
    "M-SPC c" "代码开发"
    "M-SPC g" "Git 操作"
    "M-SPC a" "AI 助手"
    "M-SPC o" "Org 模式"
    "M-SPC t" "终端"
    "M-SPC s" "搜索"
    "M-SPC h" "帮助"
    "M-SPC T" "切换功能"
    "," "本地 leader 键"))

;; ----------------------------------------------------------------------------
;; 快捷键验证与修复函数
;; ----------------------------------------------------------------------------

(defun my-fix-keybinding-conflicts ()
  "修复键绑定冲突。M-SPC 作为 leader 键通常不与 evil 冲突。"
  (interactive)
  (message "✅ M-SPC leader 键不需要额外修复（无已知冲突）"))

(defun my-verify-keybindings ()
  "验证快捷键配置是否正常。仅在发现问题时显示警告。"
  (interactive)
  (let ((issues '()))
    (unless (bound-and-true-p which-key-mode)
      (push "which-key-mode 未启用" issues))
    (unless (featurep 'general)
      (push "general 包未加载" issues))
    ;; SPC 通过 general-override-mode-map (emulation-mode-map-alists) 工作，
    ;; 不再依赖 evil state maps 中的绑定状态
    (when issues
      (message "⚠️  快捷键配置问题: %s" (string-join issues ", ")))
    (when (called-interactively-p 'any)
      (if issues
          (message "⚠️  快捷键配置问题: %s" (string-join issues ", "))
        (message "✅ 快捷键配置正常")))))

;; 启动时验证并修复快捷键配置
(add-hook 'emacs-startup-hook 'my-verify-keybindings)

;; 添加一个命令来手动检查和修复键绑定
(defun my-check-and-fix-keybindings ()
  "检查并修复所有键绑定问题。"
  (interactive)
  (my-verify-keybindings)
  (my-fix-keybinding-conflicts)
  (message "✅ 键绑定检查与修复完成"))

(provide 'init-keybind)
;;; init-keybind.el ends here
