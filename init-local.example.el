;;; init-local.example.el --- Example Local configuration -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------------
;; 用户个人信息 (用于 Git, Emacs 签名等)
;; ----------------------------------------------------------------------------
(setq user-full-name "Your Name")
(setq user-mail-address "your-email@example.com")

;; 当修改上述信息时，可选择将其同步到全局 Git 配置
;; 你可以在系统中取消注释下面的代码让 Emacs 启动时自动设置 Git 用户信息
;; (when (executable-find "git")
;;   (shell-command (format "git config --global user.name \"%s\"" user-full-name))
;;   (shell-command (format "git config --global user.email \"%s\"" user-mail-address)))

;; ----------------------------------------------------------------------------
;; 代理配置 (支持认证格式)
;; ----------------------------------------------------------------------------
(setq my-proxy-enable t)      ; 设置为 t 会自动开启代理，设为 nil 关闭

;; 方式1: 使用完整URL格式 (推荐，支持认证)
;; 格式示例:
;; - "127.0.0.1:7890"                    (无认证)
;; - "user:password@127.0.0.1:7890"      (基础认证)
;; - "http://user:pass@proxy.com:8080"   (完整URL)
;; - "socks5://127.0.0.1:1080"           (SOCKS5代理)
(setq my-proxy-url "127.0.0.1:7890")

;; 方式2: 使用分开的host/port变量 (旧方式，向后兼容)
;; 当 my-proxy-url 为 nil 时使用
(setq my-proxy-host "127.0.0.1")
(setq my-proxy-port "7890")

;; 代理认证信息 (如果URL中已包含，则不需要单独设置)
(setq my-proxy-username nil)
(setq my-proxy-password nil)

;; 不代理的主机列表
(setq my-proxy-no-proxy "localhost,127.0.0.1,10.*,192.168.*,*.local")

;; ----------------------------------------------------------------------------
;; AI 助手配置 (API Key 等) - 安全最佳实践
;; ----------------------------------------------------------------------------
;; 方法1: 使用环境变量 (推荐)
;; 在系统环境变量中设置 OPENAI_API_KEY，然后在这里读取
(setq my-gptel-api-key (getenv "OPENAI_API_KEY"))

;; 方法2: 使用 auth-source (Emacs 内置密码管理)
;; 首先在 ~/.authinfo 或 ~/.authinfo.gpg 中添加:
;; machine api.openai.com login token password YOUR_API_KEY
;; 然后取消注释下面这行:
;; (setq my-gptel-api-key
;;       (auth-source-pick-first-password :host "api.openai.com"))

;; 方法3: 直接设置 (不推荐，仅用于测试)
;; (setq my-gptel-api-key "YOUR_API_KEY_HERE")

(setq my-gptel-model "gpt-4o")
;; 可以根据自己使用的代理或国内镜像修改 Base URL
(setq my-gptel-host "api.openai.com")

;; ----------------------------------------------------------------------------
;; 其他敏感信息配置示例
;; ----------------------------------------------------------------------------
;; GitHub Token 示例 (使用环境变量)
;; (setq my-github-token (getenv "GITHUB_TOKEN"))

;; 数据库密码示例 (使用 auth-source)
;; (setq my-db-password
;;       (auth-source-pick-first-password :host "db.example.com" :user "myuser"))

(provide 'init-local)
;;; init-local.example.el ends here