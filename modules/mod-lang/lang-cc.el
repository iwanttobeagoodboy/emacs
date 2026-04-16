;;; lang-cc.el --- C/C++ support -*- lexical-binding: t -*-

(use-package cc-mode
  :ensure nil
  :mode (("\\.c\\'" . c-ts-mode)
         ("\\.cpp\\'" . c++-ts-mode)
         ("\\.h\\'" . c++-ts-mode)
         ("\\.hpp\\'" . c++-ts-mode))
  :config
  ;; 设置缩进宽度
  (setq c-basic-offset 4)
  
  ;; 设置默认的代码风格为 bsd (Allman 风格，大括号换行)
  (setq c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (other . "bsd")))
  
  ;; Tree-sitter 下的 C/C++ 缩进风格
  (setq c-ts-mode-indent-style 'bsd)
  
  ;; 修复 flymake-cc 在 c++-ts-mode 下的报错问题
  ;; 强制在 C++ 环境下使用 g++ 并支持 C++17 等现代特性，避免语法报错
  (defun my-flymake-cc-c++-setup ()
    (setq-local flymake-cc-command '("g++" "-Wall" "-Wextra" "-fsyntax-only" "-std=c++17" "-x" "c++" "-")))
  
  (add-hook 'c++-mode-hook #'my-flymake-cc-c++-setup)
  (add-hook 'c++-ts-mode-hook #'my-flymake-cc-c++-setup))

(provide 'lang-cc)
;;; lang-cc.el ends here