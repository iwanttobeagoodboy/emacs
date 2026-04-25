;;; mod-terminal.el --- Terminal and Debugging -*- lexical-binding: t -*-

;; 调试: Dape (DAP 客户端)
(use-package dape
  :ensure t
  :config
  ;; 启用全局 minibuffer 提示
  (add-hook 'dape-on-start-hooks (lambda () (save-some-buffers t t)))
  (setq dape-buffer-window-arrangement 'right))

(provide 'mod-terminal)
;;; mod-terminal.el ends here