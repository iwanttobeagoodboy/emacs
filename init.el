;;; init.el --- Emacs Initialization File -*- lexical-binding: t -*-

;; 添加 lisp 和 modules 目录到加载路径
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "modules/mod-lang" user-emacs-directory))

;; 加载本地隐私配置 (如果不存则跳过)
;; 可以在此文件中配置诸如 API Key, Proxy 等私密信息
(let ((local-file (expand-file-name "init-local.el" user-emacs-directory)))
  (when (file-exists-p local-file)
    (load local-file)))

;; Phase 1: 基础设施与性能
(require 'init-proxy)
(require 'init-package)
(require 'init-performance)
(require 'init-basic)
(require 'init-ui)
(require 'init-keybind)

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