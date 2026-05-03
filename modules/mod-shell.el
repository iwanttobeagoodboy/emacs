;;; mod-shell.el --- 终端与 Shell 增强 -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 1. Windows 进程编码修复
;; ──────────────────────────────────────────────────────
;; 子进程输入用 UTF-8 编码，输出按 GBK 解码（Windows 中文系统默认编码）
(when (eq system-type 'windows-nt)
  (setq default-process-coding-system '(utf-8 . chinese-gbk-dos)))

;; ──────────────────────────────────────────────────────
;; 2. Eshell: Emacs 内置 Shell
;; ──────────────────────────────────────────────────────
(use-package eshell
  :ensure nil
  :hook (eshell-mode . (lambda () (display-line-numbers-mode -1)))
  :custom
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-scroll-to-bottom-on-input t)
  (eshell-history-size 10000)
  (eshell-buffer-maximum-lines 10000)
  (eshell-visual-commands
   '("vim" "nano" "less" "more" "top" "htop" "watch"))
  :config
  ;; GUI 程序异步执行：在 eshell 中输入 run ./main.exe
  ;; Windows 用 ShellExecute API 启动，确保 GUI 窗口能正常弹出
  (defun my/eshell-run-async (program &rest args)
    "异步运行 PROGRAM ARGS，不阻塞 Emacs（适用于 GUI 程序）。"
    (let ((prog (expand-file-name program)))
      (if (eq system-type 'windows-nt)
          (w32-shell-execute "open" prog)
        (apply #'start-process (file-name-nondirectory prog) nil prog args))
      (message "Started: %s" prog)))

  (defalias 'eshell/run 'my/eshell-run-async)

  ;; 快捷键
  (my-leader-def
    "o e" 'eshell))

;; ──────────────────────────────────────────────────────
;; 3. C/C++ stdout 缓冲问题
;; ──────────────────────────────────────────────────────
;; eshell 不是真正的终端，C/C++ stdout 会变全缓冲（4KB 才刷新）
;; 现象：printf 输出看不到，程序退出后才一次性出现
;; 修复：在 main() 开头加一行
;;   setvbuf(stdout, NULL, _IONBF, 0);   // C
;;   std::cout.setf(std::ios::unitbuf);   // C++

(provide 'mod-shell)
;;; mod-shell.el ends here
