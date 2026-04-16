;;; init-search.el --- Search and Minibuffer -*- lexical-binding: t -*-

;; Vertico: 垂直 Minibuffer
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  (setq vertico-cycle t))

;; Orderless: 无序模糊匹配
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; Consult: 增强搜索
(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("C-c r" . consult-recent-file)))

;; Marginalia: Minibuffer 注释
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; Embark: Minibuffer 操作
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(provide 'init-search)
;;; init-search.el ends here