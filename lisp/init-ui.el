;;; init-ui.el --- UI Settings -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------------
;; 字体设置
;; ----------------------------------------------------------------------------
(defun my-setup-fonts ()
  "Setup default English font and fallback Chinese fonts."
  (interactive)
  ;; 1. 默认/英文字体设置
  ;; 推荐使用等宽字体：Consolas, JetBrains Mono, Cascadia Code, Fira Code 等
  (let ((en-fonts '("JetBrains Mono" "Cascadia Code" "Fira Code" "Consolas" "Hack" "monospace")))
    (catch 'found
      (dolist (f en-fonts)
        (when (member f (font-family-list))
          (set-face-attribute 'default nil :family f :height 130)
          (throw 'found t)))))

  ;; 2. 中文后备字体设置
  ;; 推荐：微软雅黑, 苹方, 文泉驿等
  (let ((zh-fonts '("Microsoft YaHei" "PingFang SC" "STHeiti" "WenQuanYi Micro Hei" "Sarasa Gothic SC")))
    (catch 'found
      (dolist (f zh-fonts)
        (when (member f (font-family-list))
          ;; 将找到的第一个中文字体应用到字符集 'han 和 'cjk-misc
          (set-fontset-font t 'han (font-spec :family f))
          (set-fontset-font t 'cjk-misc (font-spec :family f))
          ;; 针对中文字体微调缩放比例，使其与英文字体等宽对齐 (可根据需要调整比例 1.1~1.3)
          (add-to-list 'face-font-rescale-alist `(,f . 1.2))
          (throw 'found t))))))

;; 初始化字体 (兼顾 Daemon 模式启动的情况)
(if (daemonp)
    (add-hook 'server-after-make-frame-hook #'my-setup-fonts)
  (my-setup-fonts))

;; 主题
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; 状态栏
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 30))

;; 图标
(use-package nerd-icons
  :ensure t)

;; 更好的显示行号
(use-package display-line-numbers
  :ensure nil
  :hook ((prog-mode text-mode) . display-line-numbers-mode)
  :custom
  (display-line-numbers-type 'relative))

(provide 'init-ui)
;;; init-ui.el ends here