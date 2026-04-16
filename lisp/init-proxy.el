;;; init-proxy.el --- Proxy configuration -*- lexical-binding: t -*-

;; 代理主机
(defvar my-proxy-host "127.0.0.1"
  "Proxy host.")

;; 代理端口，默认 7890 (Clash等常用端口)
(defvar my-proxy-port "7890"
  "Proxy port.")

;; 是否默认开启代理
(defvar my-proxy-enable nil
  "Enable proxy by default.")

(defun proxy-enable ()
  "Enable proxy."
  (interactive)
  (let ((proxy (format "http://%s:%s" my-proxy-host my-proxy-port))
        (socks (format "socks5://%s:%s" my-proxy-host my-proxy-port)))
    (setq url-proxy-services `(("no_proxy" . "^\\(localhost\\|10\\..*\\|192\\.168\\..*\\)")
                               ("http" . ,(format "%s:%s" my-proxy-host my-proxy-port))
                               ("https" . ,(format "%s:%s" my-proxy-host my-proxy-port))))
    (setenv "http_proxy" proxy)
    (setenv "https_proxy" proxy)
    (setenv "all_proxy" socks)
    (message "Proxy enabled: %s" proxy)))

(defun proxy-disable ()
  "Disable proxy."
  (interactive)
  (setq url-proxy-services nil)
  (setenv "http_proxy" nil)
  (setenv "https_proxy" nil)
  (setenv "all_proxy" nil)
  (message "Proxy disabled."))

;; 默认根据本地配置启动代理，避免直接在代码写死引发卡顿
(when my-proxy-enable
  (proxy-enable))

(provide 'init-proxy)
;;; init-proxy.el ends here