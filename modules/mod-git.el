;;; mod-git.el --- Magit 版本控制与侧边栏高亮 -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 1. Magit: Emacs 生态的杀手级应用
;; ──────────────────────────────────────────────────────
(use-package magit
  ;; 绑定到极其顺手的原生位置（取代没用的原版 C-x g 行为）
  :bind ("C-x g" . magit-status)
  :custom
  ;; 在当前窗口打开 Magit 状态面板，而不是弹出个小窗，保护心流
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; ──────────────────────────────────────────────────────
;; 2. Diff-hl: 在行号左侧显示 Git 变动状态 (增删改)
;; ──────────────────────────────────────────────────────
(use-package diff-hl
  :init
  ;; 开启全局高亮显示
  (global-diff-hl-mode)
  ;; 在 dired (Emacs 的文件管理器) 中也显示文件的 Git 状态
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  :hook 
  ;; 当在 Magit 中提交代码后，自动刷新代码侧边的颜色条
  ((magit-pre-refresh . diff-hl-magit-pre-refresh)
   (magit-post-refresh . diff-hl-magit-post-refresh)))

(provide 'mod-git)
;;; mod-git.el ends here