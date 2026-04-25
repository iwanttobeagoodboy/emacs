;;; init-proxy.el --- Proxy configuration with authentication support -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------------
;; 代理配置变量
;; ----------------------------------------------------------------------------

;; 代理地址格式支持：
;; 1. 简单格式: "127.0.0.1:7890"
;; 2. 认证格式: "user:pass@127.0.0.1:7890"
;; 3. 完整URL格式: "http://user:pass@127.0.0.1:7890"

(defvar my-proxy-url nil
  "Proxy URL in format 'host:port', 'user:pass@host:port' or full URL.
If nil, will use my-proxy-host and my-proxy-port.")

(defvar my-proxy-host "127.0.0.1"
  "Proxy host. Used when my-proxy-url is nil.")

(defvar my-proxy-port "7890"
  "Proxy port. Used when my-proxy-url is nil.")

(defvar my-proxy-username nil
  "Proxy username for authentication.")

(defvar my-proxy-password nil
  "Proxy password for authentication.")

(defvar my-proxy-enable nil
  "Enable proxy by default.")

(defvar my-proxy-no-proxy "localhost,127.0.0.1,10.*,192.168.*,*.local"
  "Comma-separated list of hosts that should not use proxy.")

;; ----------------------------------------------------------------------------
;; 代理解析函数
;; ----------------------------------------------------------------------------

(defun my-parse-proxy-url (url)
  "Parse proxy URL and return (host port username password).
Supports formats:
- 'host:port'
- 'user:pass@host:port'
- 'http://user:pass@host:port'
- 'socks5://host:port'"
  (when (and url (not (string-empty-p url)))
    (let* ((url (replace-regexp-in-string "^\\(https?\\|socks5\\)://" "" url))
           (auth-host (split-string url "@"))
           host port username password)
      
      (if (> (length auth-host) 1)
          ;; 有认证信息: user:pass@host:port
          (let ((auth (car auth-host))
                (hostport (cadr auth-host)))
            (setq username (car (split-string auth ":")))
            (setq password (cadr (split-string auth ":")))
            (setq host (car (split-string hostport ":")))
            (setq port (cadr (split-string hostport ":"))))
        ;; 无认证信息: host:port
        (let ((hostport (car auth-host)))
          (setq host (car (split-string hostport ":")))
          (setq port (cadr (split-string hostport ":")))))
      
      (list host port username password))))

(defun my-build-proxy-url (&optional host port username password)
  "Build proxy URL from components."
  (let ((host (or host my-proxy-host))
        (port (or port my-proxy-port))
        (username (or username my-proxy-username))
        (password (or password my-proxy-password)))
    
    (cond
     ((and username password)
      (format "http://%s:%s@%s:%s" username password host port))
     (t
      (format "http://%s:%s" host port)))))

;; ----------------------------------------------------------------------------
;; 代理启用/禁用函数
;; ----------------------------------------------------------------------------

(defun proxy-enable ()
  "Enable proxy with authentication support."
  (interactive)
  (let* ((parsed (if my-proxy-url
                     (my-parse-proxy-url my-proxy-url)
                   (list my-proxy-host my-proxy-port my-proxy-username my-proxy-password)))
         (host (nth 0 parsed))
         (port (nth 1 parsed))
         (username (nth 2 parsed))
         (password (nth 3 parsed))
         (proxy-url (my-build-proxy-url host port username password))
         (socks-url (format "socks5://%s:%s" host port)))
    
    ;; 设置 url-proxy-services (Emacs 内置代理)
    (setq url-proxy-services
          `(("no_proxy" . ,(concat "^\\(" (replace-regexp-in-string "," "\\\\|" my-proxy-no-proxy) "\\)"))
            ("http" . ,(format "%s:%s" host port))
            ("https" . ,(format "%s:%s" host port))))
    
    ;; 设置环境变量 (用于外部命令)
    (setenv "http_proxy" proxy-url)
    (setenv "https_proxy" proxy-url)
    (setenv "all_proxy" socks-url)
    (setenv "no_proxy" my-proxy-no-proxy)
    
    ;; 如果有认证信息，设置认证
    (when (and username password)
      (setq url-http-proxy-auth (list (cons (format "%s:%s" host port)
                                            (base64-encode-string (format "%s:%s" username password))))))
    
    (message "✅ 代理已启用: %s" proxy-url)))

(defun proxy-disable ()
  "Disable proxy."
  (interactive)
  (setq url-proxy-services nil)
  (setq url-http-proxy-auth nil)
  (setenv "http_proxy" nil)
  (setenv "https_proxy" nil)
  (setenv "all_proxy" nil)
  (setenv "no_proxy" nil)
  (message "✅ 代理已禁用"))

(defun proxy-toggle ()
  "Toggle proxy on/off."
  (interactive)
  (if url-proxy-services
      (proxy-disable)
    (proxy-enable)))

;; ----------------------------------------------------------------------------
;; 代理配置检查函数
;; ----------------------------------------------------------------------------

(defun my-check-proxy-config ()
  "检查当前代理配置状态。"
  (interactive)
  (let ((http-proxy (getenv "http_proxy"))
        (https-proxy (getenv "https_proxy"))
        (no-proxy (getenv "no_proxy")))
    
    (message "当前代理配置:")
    (message "  HTTP_PROXY: %s" (or http-proxy "未设置"))
    (message "  HTTPS_PROXY: %s" (or https-proxy "未设置"))
    (message "  NO_PROXY: %s" (or no-proxy "未设置"))
    (message "  url-proxy-services: %s" (if url-proxy-services "已设置" "未设置"))
    
    (when url-http-proxy-auth
      (message "  代理认证: 已配置"))))

;; ----------------------------------------------------------------------------
;; 环境变量集成
;; ----------------------------------------------------------------------------

(defun my-load-proxy-from-env ()
  "从环境变量加载代理配置。"
  (let ((http-proxy (getenv "HTTP_PROXY"))
        (https-proxy (getenv "HTTPS_PROXY")))
    (when (or http-proxy https-proxy)
      (let ((proxy (or http-proxy https-proxy)))
        (setq my-proxy-url proxy)
        (message "从环境变量加载代理配置: %s" proxy)))))

;; 启动时尝试从环境变量加载
(my-load-proxy-from-env)

;; ----------------------------------------------------------------------------
;; 默认配置
;; ----------------------------------------------------------------------------

;; 默认根据本地配置启动代理
(when my-proxy-enable
  (proxy-enable))

;; ----------------------------------------------------------------------------
;; 快捷键绑定
;; ----------------------------------------------------------------------------

(defun my-setup-proxy-keybindings ()
  "设置代理相关快捷键。"
  (global-set-key (kbd "C-c p x") 'proxy-toggle)
  (global-set-key (kbd "C-c p e") 'proxy-enable)
  (global-set-key (kbd "C-c p d") 'proxy-disable)
  (global-set-key (kbd "C-c p c") 'my-check-proxy-config))

(my-setup-proxy-keybindings)

(provide 'init-proxy)
;;; init-proxy.el ends here