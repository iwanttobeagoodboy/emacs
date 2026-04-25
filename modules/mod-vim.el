;;; mod-vim.el --- Vim Mode Integration for Programming Efficiency -*- lexical-binding: t -*-

;; ============================================================================
;; Vim模式优化配置
;; 目标：在编程模式下使用Vim键绑定提高编辑效率，同时保持Emacs其他功能的完整性
;; ============================================================================

;; ----------------------------------------------------------------------------
;; 1. 核心Vim模拟：Evil
;; ----------------------------------------------------------------------------
(use-package evil
  :ensure t
  :init
  ;; 延迟加载evil，避免影响启动速度
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-redo)  ;; Emacs 28+ 支持
  :config
  ;; 启用evil模式
  (evil-mode 1)
  
  ;; 设置默认状态为normal
  (setq evil-default-state 'normal)
  
  ;; 在特定模式中默认使用normal状态
  (dolist (mode '(prog-mode-hook text-mode-hook))
    (add-hook mode (lambda () (evil-normal-state))))
  
  ;; 定义状态切换命令
  (defun my-toggle-vim-mode ()
    "切换Vim模式开关"
    (interactive)
    (if evil-mode
        (progn
          (evil-mode -1)
          (message "Vim模式已禁用"))
      (progn
        (evil-mode 1)
        (message "Vim模式已启用"))))
  
  ;; 绑定切换命令
  (global-set-key (kbd "C-c v") 'my-toggle-vim-mode))

;; ----------------------------------------------------------------------------
;; 2. Evil扩展集合：为各种模式提供Vim键绑定
;; ----------------------------------------------------------------------------
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init)
  
  ;; 配置排除列表：在这些模式中保持Emacs键绑定
  (setq evil-collection-mode-list
        (remove 'magit evil-collection-mode-list))
  (setq evil-collection-mode-list
        (remove 'dired evil-collection-mode-list))
  (setq evil-collection-mode-list
        (remove 'eshell evil-collection-mode-list))
  (setq evil-collection-mode-list
        (remove 'term evil-collection-mode-list))
  (setq evil-collection-mode-list
        (remove 'vterm evil-collection-mode-list))
  
  ;; 特殊模式配置
  (with-eval-after-load 'magit
    (evil-set-initial-state 'magit-status-mode 'emacs)
    (evil-set-initial-state 'magit-log-mode 'emacs))
  
  (with-eval-after-load 'dired
    (evil-set-initial-state 'dired-mode 'emacs))
  
  (with-eval-after-load 'eshell
    (evil-set-initial-state 'eshell-mode 'emacs))
  
  (with-eval-after-load 'org
    (evil-set-initial-state 'org-mode 'normal)))

;; ----------------------------------------------------------------------------
;; 3. 快速退出插入模式
;; ----------------------------------------------------------------------------
(use-package evil-escape
  :ensure t
  :after evil
  :config
  (setq evil-escape-key-sequence "jk")
  (setq evil-escape-delay 0.2)
  (evil-escape-mode 1))

;; ----------------------------------------------------------------------------
;; 4. Surround功能（Vim的surround.vim）
;; ----------------------------------------------------------------------------
(use-package evil-surround
  :ensure t
  :after evil
  :config
  (global-evil-surround-mode 1))

;; ----------------------------------------------------------------------------
;; 5. 注释功能（Vim的commentary）
;; ----------------------------------------------------------------------------
(use-package evil-commentary
  :ensure t
  :after evil
  :config
  (evil-commentary-mode 1))

;; ----------------------------------------------------------------------------
;; 6. 数字增减功能
;; ----------------------------------------------------------------------------
(use-package evil-numbers
  :ensure t
  :after evil
  :bind (:map evil-normal-state-map
         ("C-a" . evil-numbers/inc-at-pt)
         ("C-x" . evil-numbers/dec-at-pt)))

;; ----------------------------------------------------------------------------
;; 7. 与现有键绑定集成
;; ----------------------------------------------------------------------------
(with-eval-after-load 'evil
  ;; 保留C-c作为领导键
  (evil-define-key 'normal 'global
    (kbd "C-c") nil)  ;; 清空C-c绑定，让general.el处理
  
  ;; 在insert模式下使用Emacs风格的移动
  (define-key evil-insert-state-map (kbd "C-a") 'move-beginning-of-line)
  (define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
  (define-key evil-insert-state-map (kbd "C-k") 'kill-line)
  
  ;; 在normal模式下使用Emacs的undo/redo
  (define-key evil-normal-state-map (kbd "C-/") 'undo)
  (define-key evil-normal-state-map (kbd "C-?") 'undo-redo)
  
  ;; 注意：不覆盖C-x绑定，因为evil可能已经将其用于其他功能
  ;; 用户可以使用Vim的窗口命令或保持现有的C-x绑定
  ;; 如果需要Emacs风格的窗口操作，可以在emacs-state中使用
  )

;; ----------------------------------------------------------------------------
;; 8. 编程特定优化
;; ----------------------------------------------------------------------------
(defun my-setup-vim-for-programming ()
  "为编程模式设置特定的Vim配置"
  (when (derived-mode-p 'prog-mode)
    ;; 启用相对行号
    (when (fboundp 'display-line-numbers-mode)
      (display-line-numbers-mode 1))
    
    ;; 设置缩进
    (setq evil-shift-width tab-width)
    
    ;; 启用自动配对
    (electric-pair-local-mode 1)))

(add-hook 'prog-mode-hook 'my-setup-vim-for-programming)

;; ----------------------------------------------------------------------------
;; 9. 状态栏显示 (使用 doom-modeline 内置的 evil 状态显示)
;; ----------------------------------------------------------------------------
(setq doom-modeline-modal t)

;; 提供一个自定义的状态指示器函数，用于内联使用
(defun my-evil-state-indicator ()
  "返回当前 evil 状态的简短字符串。"
  (if evil-mode
      (cond
       ((evil-normal-state-p) "NORMAL")
       ((evil-insert-state-p) "INSERT")
       ((evil-visual-state-p) "VISUAL")
       ((evil-motion-state-p) "MOTION")
       ((evil-emacs-state-p) "EMACS")
       (t "???"))
    "EMACS"))

;; ----------------------------------------------------------------------------
;; 10. 验证函数
;; ----------------------------------------------------------------------------
(defun my-verify-vim-config ()
  "验证Vim模式配置"
  (interactive)
  (message "=== Vim模式配置验证 ===")
  (message "1. Evil模式: %s" (if evil-mode "已启用" "未启用"))
  (message "2. Evil-collection: %s" (if (featurep 'evil-collection) "已加载" "未加载"))
  (message "3. Evil-escape: %s" (if (bound-and-true-p evil-escape-mode) "已启用" "未启用"))
  (message "4. Evil-surround: %s" (if (bound-and-true-p global-evil-surround-mode) "已启用" "未启用"))
  (message "5. Evil-commentary: %s" (if (bound-and-true-p evil-commentary-mode) "已启用" "未启用"))
  (message "6. 当前状态: %s" (my-evil-state-indicator))
  (message "=== 验证完成 ==="))

;; 添加到帮助菜单
(define-key help-map (kbd "V") 'my-verify-vim-config)

;; ----------------------------------------------------------------------------
;; 11. 提供模块
;; ----------------------------------------------------------------------------
(provide 'mod-vim)
;;; mod-vim.el ends here
