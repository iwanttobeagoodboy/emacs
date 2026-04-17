;;; mod-terminal.el --- Terminal and Debugging -*- lexical-binding: t -*-

;; 终端模拟器: Vterm 或 Eat
;; 这里使用 vterm 作为默认推荐
;(use-package vterm
;  :ensure t)

;; 调试: Dape (DAP 客户端)
(use-package dape
  :ensure t
  :config
  ;; 启用全局 minibuffer 提示
  (add-hook 'dape-on-start-hooks (lambda () (save-some-buffers t t)))
  (setq dape-buffer-window-arrangement 'right))

(provide 'mod-terminal)
;;; mod-terminal.el ends here