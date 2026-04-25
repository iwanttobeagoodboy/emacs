;;; init-ui.el --- UI Settings -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------------
;; 字体设置
;; ----------------------------------------------------------------------------
(defun my-setup-fonts ()
  "Setup default English font with Nerd Fonts support and fallback Chinese fonts."
  (interactive)
  ;; 1. 默认/英文字体设置 - 优先使用 Nerd Fonts
  ;; Nerd Fonts 提供了丰富的图标支持，推荐安装 FiraCode Nerd Font, JetBrainsMono Nerd Font 等
  (let ((en-fonts '("FiraCode Nerd Font"
                    "JetBrainsMono Nerd Font"
                    "Cascadia Code PL"
                    "CaskaydiaCove Nerd Font"
                    "Hack Nerd Font"
                    "JetBrains Mono"
                    "Cascadia Code"
                    "Fira Code"
                    "Consolas"
                    "Hack"
                    "monospace")))
    (unless (catch 'found
              (dolist (f en-fonts)
                (when (member f (font-family-list))
                  (set-face-attribute 'default nil :family f :height 130)
                  (message "使用字体: %s" f)
                  (throw 'found t))))
      (message "警告: 未找到推荐的等宽字体，请考虑安装 Nerd Fonts")))

  ;; 2. 中文后备字体设置
  ;; 推荐：微软雅黑, 苹方, 文泉驿等
  (let ((zh-fonts '("Microsoft YaHei" "PingFang SC" "STHeiti" "WenQuanYi Micro Hei" "Sarasa Gothic SC" "Source Han Sans SC")))
    (unless (catch 'found
              (dolist (f zh-fonts)
                (when (member f (font-family-list))
                  ;; 将找到的第一个中文字体应用到字符集 'han 和 'cjk-misc
                  (set-fontset-font t 'han (font-spec :family f))
                  (set-fontset-font t 'cjk-misc (font-spec :family f))
                  ;; 针对中文字体微调缩放比例，使其与英文字体等宽对齐 (可根据需要调整比例 1.1~1.3)
                  (add-to-list 'face-font-rescale-alist `(,f . 1.2))
                  (message "使用中文字体: %s" f)
                  (throw 'found t))))
      (message "警告: 未找到推荐的中文字体，请考虑安装中文字体"))))

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

;; 图标系统 - 使用 all-the-icons 替代 nerd-icons，兼容性更好
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p)
  :config
  ;; 禁用自动字体安装，避免弹窗
  (setq all-the-icons-scale-factor 1.0
        all-the-icons-default-adjust 0.0)
  ;; 仅当字体不存在时显示警告，但不自动安装
  (when (and (display-graphic-p) (not (member "all-the-icons" (font-family-list))))
    (message "警告: all-the-icons 字体未安装，图标可能无法正常显示。如需安装请手动运行 M-x all-the-icons-install-fonts")))

;; 状态栏 - 配置 doom-modeline 使用 all-the-icons
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 30)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-minor-modes nil)
  (doom-modeline-enable-word-count nil)
  (doom-modeline-buffer-encoding t)
  (doom-modeline-indent-info nil)
  (doom-modeline-checker-simple-format t)
  (doom-modeline-vcs-max-length 12)
  (doom-modeline-persp-name t)
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-mu4e nil)
  (doom-modeline-irc nil)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  :config
  ;; 确保 doom-modeline 使用 all-the-icons
  (setq doom-modeline-icon (display-graphic-p)))

;; 图标补全支持
(use-package all-the-icons-completion
  :ensure t
  :after (all-the-icons marginalia)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

;; 更好的显示行号
(use-package display-line-numbers
  :ensure nil
  :hook ((prog-mode text-mode) . display-line-numbers-mode)
  :custom
  (display-line-numbers-type 'relative))

;; 字体检查函数
(defun my-check-fonts ()
  "检查系统字体安装情况，特别是 Nerd Fonts。"
  (interactive)
  (let ((nerd-fonts '("FiraCode Nerd Font" "JetBrainsMono Nerd Font" "Cascadia Code PL"
                      "CaskaydiaCove Nerd Font" "Hack Nerd Font"))
        (available-nerd-fonts '())
        (available-normal-fonts '()))
    
    (dolist (font nerd-fonts)
      (when (member font (font-family-list))
        (push font available-nerd-fonts)))
    
    (dolist (font '("JetBrains Mono" "Fira Code" "Cascadia Code" "Consolas" "Hack"))
      (when (member font (font-family-list))
        (push font available-normal-fonts)))
    
    (if available-nerd-fonts
        (message "✅ 已安装 Nerd Fonts: %s" (string-join available-nerd-fonts ", "))
      (message "⚠️  未检测到 Nerd Fonts，建议安装以获得更好的图标体验"))
    
    (when available-normal-fonts
      (message "✅ 已安装普通等宽字体: %s" (string-join available-normal-fonts ", ")))))

(provide 'init-ui)
;;; init-ui.el ends here