;;; lang-python.el --- Python support -*- lexical-binding: t -*-

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :config
  (setq python-indent-offset 4))

(provide 'lang-python)
;;; lang-python.el ends here