;;; init-performance.el --- Performance Optimization -*- lexical-binding: t -*-

;; 恢复垃圾回收默认阈值 (通过 gcmh 管理)
(use-package gcmh
  :ensure t
  :init
  (gcmh-mode 1)
  :config
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 64 1024 1024)  ;; 增加到 64MB
        gcmh-verbose t))  ;; 启用详细日志

;; 启动时间测量
(defvar my-emacs-start-time (current-time))

(add-hook 'emacs-startup-hook
  (lambda ()
    ;; 显示启动时间
    (message "Emacs 启动完成，耗时 %.2f 秒"
             (float-time (time-subtract (current-time) my-emacs-start-time)))
    
    ;; 重置 file-name-handler-alist
    (setq file-name-handler-alist file-name-handler-alist-original)))

;; 记录原始值在 early-init 或使用默认
(defvar file-name-handler-alist-original file-name-handler-alist)

;; 性能监控工具
(use-package benchmark-init
  :ensure t
  :config
  (benchmark-init/activate)
  (add-hook 'emacs-startup-hook 'benchmark-init/deactivate))

(provide 'init-performance)
;;; init-performance.el ends here