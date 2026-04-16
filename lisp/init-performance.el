;;; init-performance.el --- Performance Optimization -*- lexical-binding: t -*-

;; 恢复垃圾回收默认阈值 (通过 gcmh 管理)
(use-package gcmh
  :ensure t
  :init
  (gcmh-mode 1)
  :config
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 16 1024 1024)))

;; 启动完毕后重置 file-name-handler-alist
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist file-name-handler-alist-original)))

;; 记录原始值在 early-init 或使用默认
(defvar file-name-handler-alist-original file-name-handler-alist)

(provide 'init-performance)
;;; init-performance.el ends here