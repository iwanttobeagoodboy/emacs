;;; init.el --- Emacs Initialization File -*- lexical-binding: t -*-

;; 设置 custom-file 避免自定义变量污染主配置
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; 添加 lisp 和 modules 目录到加载路径
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "modules/mod-lang" user-emacs-directory))

;; 加载本地隐私配置 (如果不存则跳过)
;; 可以在此文件中配置诸如 API Key, Proxy 等私密信息
(let ((local-file (expand-file-name "init-local.el" user-emacs-directory)))
  (if (file-exists-p local-file)
      (load local-file)
    (message "注意: init-local.el 不存在，跳过隐私配置加载。可复制 init-local.example.el 并配置个人信息。")))

;; Phase 1: 基础设施与性能
(require 'init-proxy)
(require 'init-package)
(require 'init-performance)
(require 'init-basic)
(require 'init-ui)

(require 'init-keybind)

;; Phase 2.5: Vim模式集成（编程效率优化）
(require 'mod-vim)

;; Phase 2: 补全与交互
(require 'init-search)
(require 'init-completion)

;; Phase 3: 开发环境
(require 'mod-dev)

;; Phase 4: AI 集成
(require 'mod-ai)

;; Phase 5: Org GTD 系统
(require 'mod-org)

;; Phase 6: 终端与调试
(require 'mod-terminal)
(require 'lang-python)
(require 'lang-cc)
(require 'lang-elisp)

(provide 'init)
;;; init.el ends here