;;; core-keybinds.el --- 全局按键 -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 1. 按键提示神器 (Which-key)
;; ──────────────────────────────────────────────────────
;; 作用：按下 C-c 后如果忘了后续按键，0.3秒后会在底部弹出提示菜单
(use-package which-key
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0.3))

;; ──────────────────────────────────────────────────────
;; 2. 全局按键路由 (General.el)
;; ──────────────────────────────────────────────────────
(use-package general
  :config
  ;; 定义一个叫 `my-leader-def` 的宏，把 "C-c" 作为我们的全局 Leader Key
  (general-create-definer my-leader-def
    :prefix "C-c")

  ;; 预留顶级菜单的命名空间（现在是空的，等其他配置好了我们再来填具体的）
  (my-leader-def
    "p" '(:ignore t :which-key "project (项目)")
    "c" '(:ignore t :which-key "code (代码)")
    "n" '(:ignore t :which-key "notes (笔记)")
    "o" '(:ignore t :which-key "open (面板)")
    "d" '(:ignore t :which-key "debug (调试)")))

(provide 'core-keybinds)
;;; core-keybinds.el ends here