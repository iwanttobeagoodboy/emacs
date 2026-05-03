;;; core-packages.el --- 包管理配置 -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 1. 配置包源
;; ──────────────────────────────────────────────────────
;; 清华镜像优先，MELPA 官方源作为后备（部分包如 bui 不在镜像中）
(setq package-archives
      '(("melpa"          . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("melpa-official" . "https://melpa.org/packages/")
        ("nongnu"         . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("gnu"            . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))

(setq package-archive-priorities '(("melpa"          . 100)
                                   ("melpa-official" . 90)
                                   ("nongnu"         . 50)
                                   ("gnu"            . 10)))

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
