;;; init-completion.el --- In-buffer Completion -*- lexical-binding: t -*-

;; Corfu: 文本补全弹出层
(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.1)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match 'separator)
  (corfu-preview-current 'insert)
  (corfu-preselect-first nil)
  :init
  (global-corfu-mode))

;; 整合终端补全
(use-package corfu-terminal
  :ensure t
  :unless (display-graphic-p)
  :init
  (corfu-terminal-mode +1))

;; Cape: Corfu 的后端增强
(use-package cape
  :ensure t
  :init
  ;; 基础补全后端
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;; 增强补全后端
  (add-to-list 'completion-at-point-functions #'cape-dict)
  (add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;; cape-symbol 在新版 cape 中已移除，使用 cape-elisp-symbol 替代（仅 elisp 模式）
  (add-to-list 'completion-at-point-functions #'cape-history)
  ;; 按模式特定的后端
  (add-hook 'text-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-tex t)))
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-sgml t)))
  ;; Emacs Lisp 模式的符号补全
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-elisp-symbol t)))
  :config
  ;; 设置字典文件路径
  (setq cape-dict-file (expand-file-name "dict.txt" user-emacs-directory))
  ;; 创建帮助函数查看补全后端
  (defun my-describe-completion-backends ()
    "显示当前启用的补全后端。"
    (interactive)
    (let ((backends completion-at-point-functions))
      (with-output-to-temp-buffer "*Completion Backends*"
        (princ "当前启用的补全后端:\n\n")
        (dolist (backend backends)
          (princ (format "• %s\n" backend)))
        (princ "\n使用说明:\n")
        (princ "• cape-dabbrev: 动态缩写补全\n")
        (princ "• cape-file: 文件路径补全\n")
        (princ "• cape-elisp-block: Elisp 代码块补全\n")
        (princ "• cape-keyword: 关键词补全\n")
        (princ "• cape-dict: 字典补全\n")
        (princ "• cape-abbrev: 缩写补全\n")
        (princ "• cape-history: 历史补全\n")
        (princ "• cape-tex: LaTeX 补全 (仅 text-mode)\n")
        (princ "• cape-sgml: SGML/XML 补全 (仅 prog-mode)\n")))))

(provide 'init-completion)
;;; init-completion.el ends here