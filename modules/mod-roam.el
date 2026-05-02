;;; mod-roam.el --- 网状知识库 (认知引擎) -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 0. 动态路径声明与目录初始化
;; ──────────────────────────────────────────────────────
(defvar my-roam-dir (expand-file-name "org/roam/" user-emacs-directory)
  "Roam 知识库的根目录。")

(unless (file-exists-p my-roam-dir)
  (make-directory my-roam-dir t))

;; ──────────────────────────────────────────────────────
;; 1. Org-roam 核心：原子化记录与双向联结
;; ──────────────────────────────────────────────────────
(use-package org-roam
  :defer t
  :custom
  (org-roam-directory my-roam-dir)
  (org-roam-database-connector 'sqlite-builtin)
  :init
  ;; 按键必须在 :init 定义——org-roam 靠按键触发加载，在 :config 会死锁
  (my-leader-def
    "n f" 'org-roam-node-find
    "n i" 'org-roam-node-insert
    "n r" 'org-roam-buffer-toggle)
  :config
  (org-roam-db-autosync-mode)
  (setq org-roam-capture-templates
        '(("d" "默认概念 (Default)" plain "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t))))

;; ──────────────────────────────────────────────────────
;; 2. Consult-org-roam：脑海搜索
;; ──────────────────────────────────────────────────────
(use-package consult-org-roam
  :after org-roam
  :custom
  (consult-org-roam-grep-func 'consult-ripgrep)
  :init
  (my-leader-def
    "n s" 'consult-org-roam-search)
  :config
  (consult-org-roam-mode 1))

;; ──────────────────────────────────────────────────────
;; 3. Org-roam-ui：知识图谱可视化
;; ──────────────────────────────────────────────────────
(use-package org-roam-ui
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t)
  (org-roam-ui-open-on-start t)
  :init
  (my-leader-def
    "o u" 'org-roam-ui-mode))

(provide 'mod-roam)
;;; mod-roam.el ends here
