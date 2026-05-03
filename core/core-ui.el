;;; core-ui.el --- 基础环境、备份设置与视觉配置 -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 1. 编码环境：全员 UTF-8
;; ──────────────────────────────────────────────────────
;; 确保 Emacs 在任何系统下都优先使用 UTF-8，防止中文乱码
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; ──────────────────────────────────────────────────────
;; 2. 保命机制：文件备份与自动保存 (发配到 .cache)
;; ──────────────────────────────────────────────────────
(defvar my-cache-dir (expand-file-name ".cache/" user-emacs-directory))

;; 确保缓存目录存在，避免报错
(dolist (dir '("backups" "auto-save"))
  (let ((path (expand-file-name dir my-cache-dir)))
    (unless (file-exists-p path)
      (make-directory path t))))

;; 【备份文件 (filename~)】
(setq backup-directory-alist `(("." . ,(expand-file-name "backups/" my-cache-dir)))
      backup-by-versioning t    ; 开启多版本备份（像简单的版本控制）
      kept-new-versions 5       ; 保留最新的 5 个版本
      kept-old-versions 2       ; 保留最老的 2 个版本
      delete-old-versions t     ; 自动删除超出数量的旧版本
      vc-make-backup-files t)   ; 即使是 Git 项目也照样备份，双重保险

;; 【自动保存 (#filename#)】
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" my-cache-dir) t)))

;; 禁用锁文件 (.#filename)，这在单人使用时非常烦人且容易导致同步报错
(setq create-lockfiles nil)

;; ──────────────────────────────────────────────────────
;; 3. 现代交互优化 (UX)
;; ──────────────────────────────────────────────────────
;; 光标不要闪烁，减少视觉疲劳
(blink-cursor-mode 0)

;; 跨会话持久化：命令历史、补全历史、光标位置、最近文件
(savehist-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items 50)

;; 文件被外部修改时自动刷新
(global-auto-revert-mode 1)

;; 丝滑滚动：不再像默认那样"一跳半个屏幕"
;; 逐行滚动，并在光标距离屏幕边缘 3 行处就开始移动
(setq scroll-margin 3
      scroll-conservatively 101
      scroll-step 1)

;; 默认开启行号：仅在编程模式下开启，且使用"相对行号"方便键盘跳转
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; 突出显示当前行
(global-hl-line-mode 1)

;; ──────────────────────────────────────────────────────
;; 4. 视觉主题 (Aesthetics)
;; ──────────────────────────────────────────────────────
(use-package doom-themes
  :demand t
  :config
  (load-theme 'doom-gruvbox t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; ──────────────────────────────────────────────────────
;; 5. 字体：拉丁用 JetBrainsMono NF，中日韩回退到 Sarasa
;; ──────────────────────────────────────────────────────
;(set-fontset-font t 'latin "JetBrainsMono NF" nil 'prepend)
;(set-fontset-font t 'latin "JetBrainsMono NF-12.0" nil 'prepend)
(set-face-attribute 'default 'nil
		    :font "JetBrainsMono NF"
		    :height 160)
;; Sarasa Mono SC 未安装时使用系统默认 CJK 字体（微软雅黑）
;; 安装 Sarasa 后取消下面注释:
;; (set-fontset-font t 'han   "Sarasa Mono SC" nil 'prepend)
;; (set-fontset-font t 'kana  "Sarasa Mono SC" nil 'prepend)
;; (set-fontset-font t 'cjk-misc "Sarasa Mono SC" nil 'prepend)

;; ──────────────────────────────────────────────────────
;; 6. Nerd Font 图标美化
;; ──────────────────────────────────────────────────────
(use-package nerd-icons
  :demand t)

(use-package nerd-icons-completion
  :after nerd-icons
  :config
  (nerd-icons-completion-mode))

(use-package nerd-icons-dired
  :after nerd-icons
  :hook (dired-mode . nerd-icons-dired-mode))

(provide 'core-ui)
;;; core-ui.el ends here
