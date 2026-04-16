;;; init-basic.el --- Basic Settings -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------------
;; 编码设置 (默认 UTF-8)
;; ----------------------------------------------------------------------------
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))

;; 在 Windows 下解决一些外部命令输出中文乱码的问题
(when (eq system-type 'windows-nt)
  (set-default-coding-systems 'utf-8-dos)
  (set-selection-coding-system 'utf-16le-dos)
  (setq default-process-coding-system '(utf-8-dos . utf-8-dos)))

;; 基础用户设置 (若本地配置存在则跳过，因为已在 init-local.el 中定义)
(unless (boundp 'user-full-name)
  (setq user-full-name "User"))
(unless (boundp 'user-mail-address)
  (setq user-mail-address "user@example.com"))

;; 取消备份和自动保存相关的临时文件
(setq make-backup-files nil             ; 不生成 ~ 结尾的备份文件
      vc-make-backup-files nil          ; 在版本控制下也不生成备份文件
      auto-save-default nil             ; 不自动生成 #name# 格式的保存文件
      auto-save-list-file-prefix nil    ; 不生成 .saves- 记录文件
      create-lockfiles nil)             ; 不生成 .# 锁文件

;; 防御性配置：即使有其他插件强制覆盖上述设置生成了备份文件，也统一把它们重定向到系统的临时目录
(setq backup-directory-alist `(("." . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; 自动重载改变的文件
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; 使用空格缩进，默认 4 个空格
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; 解决中文字体卡顿
(setq inhibit-compacting-font-caches t)

;; 启用较新版本的特定功能
(setq read-process-output-max (* 1024 1024)) ;; 1mb 提高 LSP 性能

;; recentf
(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 200))

;; saveplace
(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

;; 开启 Emacs Server 模式 (允许使用 emacsclient 快速连接)
(require 'server)
;; 修复 Windows 下常见的 "directory ~/.emacs.d/server is unsafe" 报错
(when (eq system-type 'windows-nt)
  (advice-add 'server-ensure-safe-dir :override #'ignore))

(unless (server-running-p)
  (ignore-errors (server-start)))

(provide 'init-basic)
;;; init-basic.el ends here