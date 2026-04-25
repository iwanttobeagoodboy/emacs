;;; early-init.el --- Early Initialization. -*- lexical-binding: t -*-

;; 提高垃圾回收阈值，加速启动
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; 关闭非必要的 UI 元素（尽早关闭避免闪烁）
(setq inhibit-startup-message t
      inhibit-startup-screen t
      inhibit-splash-screen t)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)

;; 开启 native-comp (如果在编译时启用了 native-comp)
(setq native-comp-async-report-warnings-errors nil
      native-comp-deferred-compilation t)

;; 加快文件 IO (先保存原始值，启动后恢复)
(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)


(provide 'early-init)
;;; early-init.el ends here
