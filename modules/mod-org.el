;;; mod-org.el --- Org Mode and GTD -*- lexical-binding: t -*-

(use-package org
  :ensure nil
  :config
  (setq org-directory "~/org")
  (setq org-agenda-files '("~/org/inbox.org"
                           "~/org/gtd.org"
                           "~/org/tickler.org"))
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/inbox.org" "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("j" "Journal" entry (file+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n  %i\n  %a")))
  
  ;; 导出设置
  (setq org-export-with-toc t
        org-export-with-section-numbers t
        org-export-with-smart-quotes t))

;; Org Roam: 知识管理
(use-package org-roam
  :ensure t
  :defer t
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))
  (org-roam-db-autosync-mode))

;; Hugo 博客导出
(use-package ox-hugo
  :ensure t
  :defer t
  :after org
  :config
  (setq org-hugo-default-section-directory "content/posts/"
        org-hugo-auto-set-lastmod t
        org-hugo-use-code-for-kbd t))

;; Reveal.js 演示文稿导出
(use-package ox-reveal
  :ensure t
  :defer t
  :after org
  :config
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"
        org-reveal-transition "slide"
        org-reveal-theme "black"))

;; Org 发布工作流
(defun my-org-publish-hugo ()
  "发布 Org 文件到 Hugo"
  (interactive)
  (when (y-or-n-p "确定要发布到 Hugo 吗？")
    (org-hugo-export-wim-to-md)))

(defun my-org-export-reveal ()
  "导出为 Reveal.js 演示文稿"
  (interactive)
  (org-reveal-export-to-html))

;; 添加快捷键
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c e h") 'my-org-publish-hugo)
  (define-key org-mode-map (kbd "C-c e r") 'my-org-export-reveal))

(provide 'mod-org)
;;; mod-org.el ends here