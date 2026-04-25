;;; mod-ai.el --- AI Integration -*- lexical-binding: t -*-

;; GPTel: AI 聊天助手
(use-package gptel
  :ensure t
  :defer t
  :bind (("C-c a c" . gptel)
         ("C-c a s" . gptel-send)
         ("C-c a m" . gptel-menu))
  :config
  ;; 读取隐私配置中的参数，并提供回退默认值
  (setq gptel-model (if (boundp 'my-gptel-model) my-gptel-model "gpt-4o")
        gptel-default-mode 'org-mode
        gptel-max-tokens 4000
        gptel-temperature 0.7)
  
  (when (boundp 'my-gptel-api-key)
    (setq gptel-backend (gptel-make-openai "OpenAI"
                          :host (if (boundp 'my-gptel-host) my-gptel-host "api.openai.com")
                          :key my-gptel-api-key
                          :stream t
                          :models '("gpt-4o" "gpt-4-turbo" "gpt-3.5-turbo"))))
  
  ;; 设置菜单快捷键（不再使用 use-package gptel-transient）
  (setq gptel-transient-key "C-c a t")
  
  ;; 绑定到特定模式
  (add-hook 'prog-mode-hook #'gptel-minor-mode)
  (add-hook 'org-mode-hook #'gptel-minor-mode))

;; AI 代码助手功能增强
(defun my-ai-code-review ()
  "请求 AI 代码审查"
  (interactive)
  (if (region-active-p)
      (gptel-request "请审查以下代码，指出潜在问题并提供改进建议:"
                     :context (buffer-substring (region-beginning) (region-end)))
    (message "请先选中一段代码")))

(defun my-ai-explain-code ()
  "请求 AI 解释代码"
  (interactive)
  (if (region-active-p)
      (gptel-request "请解释以下代码的功能和工作原理:"
                     :context (buffer-substring (region-beginning) (region-end)))
    (message "请先选中一段代码")))

(defun my-ai-generate-docstring ()
  "请求 AI 生成文档字符串"
  (interactive)
  (if (region-active-p)
      (gptel-request "请为以下代码生成文档字符串:"
                     :context (buffer-substring (region-beginning) (region-end)))
    (message "请先选中一段代码")))

;; 添加快捷键到 gptel-minor-mode
(with-eval-after-load 'gptel
  (define-key gptel-minor-mode-map (kbd "C-c a r") 'my-ai-code-review)
  (define-key gptel-minor-mode-map (kbd "C-c a e") 'my-ai-explain-code)
  (define-key gptel-minor-mode-map (kbd "C-c a d") 'my-ai-generate-docstring))

;; AI 配置检查
(defun my-check-ai-config ()
  "检查 AI 配置是否完整。仅在有问题时警告。"
  (unless (boundp 'my-gptel-api-key)
    (warn "警告: AI API 密钥未设置，请配置 init-local.el")))

(add-hook 'emacs-startup-hook 'my-check-ai-config)

(provide 'mod-ai)
;;; mod-ai.el ends here