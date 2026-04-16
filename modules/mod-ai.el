;;; mod-ai.el --- AI Integration -*- lexical-binding: t -*-

;; GPTel: AI 聊天助手
(use-package gptel
  :ensure t
  :config
  ;; 读取隐私配置中的参数，并提供回退默认值
  (setq gptel-model (if (boundp 'my-gptel-model) my-gptel-model "gpt-4o")
        gptel-default-mode 'org-mode)
  
  (when (boundp 'my-gptel-api-key)
    (setq gptel-backend (gptel-make-openai "OpenAI"
                          :host (if (boundp 'my-gptel-host) my-gptel-host "api.openai.com")
                          :key my-gptel-api-key
                          :stream t
                          :models '("gpt-4o" "gpt-4-turbo" "gpt-3.5-turbo")))))

(provide 'mod-ai)
;;; mod-ai.el ends here