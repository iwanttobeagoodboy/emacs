;;; core-packages.el --- 包管理配置 -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 1. 配置包源
;; ──────────────────────────────────────────────────────
(setq package-archives
      '(("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
        
(setq package-archive-priorities '(("melpa"  . 100)
                                   ("nongnu" . 50)
                                   ("gnu"    . 10)))

;; ──────────────────────────────────────────────────────
;; 2. 初始化底层包管理器 (package.el)
;; ──────────────────────────────────────────────────────
(require 'package)
(package-initialize)

;; 首次启动或索引过期时自动刷新
(unless package-archive-contents
  (package-refresh-contents))

;; ──────────────────────────────────────────────────────
;; 3. 配置 use-package
;; ──────────────────────────────────────────────────────
(require 'use-package)

(setq use-package-always-ensure t
      use-package-compute-statistics t)

(provide 'core-packages)
;;; core-packages.el ends here
