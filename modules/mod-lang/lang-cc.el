;;; lang-cc.el --- Enhanced C/C++ support with multi-compiler -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------------
;; C/C++ 模式配置
;; ----------------------------------------------------------------------------

(use-package cc-mode
  :ensure nil
  :mode (("\\.c\\'" . c-ts-mode)
         ("\\.cpp\\'" . c++-ts-mode)
         ("\\.cc\\'" . c++-ts-mode)
         ("\\.cxx\\'" . c++-ts-mode)
         ("\\.h\\'" . c++-ts-mode)
         ("\\.hpp\\'" . c++-ts-mode)
         ("\\.hh\\'" . c++-ts-mode)
         ("\\.hxx\\'" . c++-ts-mode)
         ("\\.inl\\'" . c++-ts-mode))
  :config
  ;; 设置缩进宽度
  (setq c-basic-offset 4)
  
  ;; 设置默认的代码风格为 bsd (Allman 风格，大括号换行)
  (setq c-default-style '((java-mode . "java")
                         (awk-mode . "awk")
                         (other . "bsd")))
  
  ;; Tree-sitter 下的 C/C++ 缩进风格
  (setq c-ts-mode-indent-style 'bsd)
  
  ;; 自动检测并设置合适的编译器
  (defun my-detect-c-compiler ()
    "自动检测可用的 C/C++ 编译器。"
    (cond
     ((executable-find "gcc") "gcc")
     ((executable-find "clang") "clang")
     ((executable-find "cl") "msvc")  ; Windows MSVC
     (t "gcc")))  ; 默认使用 gcc
  
  (defun my-detect-c++-compiler ()
    "自动检测可用的 C++ 编译器。"
    (cond
     ((executable-find "g++") "g++")
     ((executable-find "clang++") "clang++")
     ((executable-find "cl") "msvc")  ; Windows MSVC
     (t "g++")))  ; 默认使用 g++
  
  ;; 编译器配置函数
  (defun my-setup-c-compiler-flags ()
    "根据检测到的编译器设置编译标志。"
    (let ((c-compiler (my-detect-c-compiler))
          (c++-compiler (my-detect-c++-compiler)))
      
      ;; C 编译器标志
      (cond
       ((string= c-compiler "gcc")
        (setq-local flymake-cc-command
                    '("gcc" "-Wall" "-Wextra" "-Wpedantic" "-fsyntax-only" "-std=c17" "-x" "c" "-")))
       ((string= c-compiler "clang")
        (setq-local flymake-cc-command
                    '("clang" "-Wall" "-Wextra" "-Wpedantic" "-fsyntax-only" "-std=c17" "-x" "c" "-")))
       ((string= c-compiler "msvc")
        (setq-local flymake-cc-command
                    '("cl" "/Zs" "/std:c17" "/TC" "/nologo")))  ; MSVC 语法检查
       (t (setq-local flymake-cc-command
                      '("gcc" "-Wall" "-Wextra" "-fsyntax-only" "-std=c17" "-x" "c" "-"))))
      
      ;; C++ 编译器标志
      (cond
       ((string= c++-compiler "g++")
        (setq-local flymake-cc-c++-command
                    '("g++" "-Wall" "-Wextra" "-Wpedantic" "-fsyntax-only" "-std=c++17" "-x" "c++" "-")))
       ((string= c++-compiler "clang++")
        (setq-local flymake-cc-c++-command
                    '("clang++" "-Wall" "-Wextra" "-Wpedantic" "-fsyntax-only" "-std=c++17" "-x" "c++" "-")))
       ((string= c++-compiler "msvc")
        (setq-local flymake-cc-c++-command
                    '("cl" "/Zs" "/std:c++17" "/TP" "/nologo")))  ; MSVC 语法检查
       (t (setq-local flymake-cc-c++-command
                      '("g++" "-Wall" "-Wextra" "-fsyntax-only" "-std=c++17" "-x" "c++" "-"))))
      
      (message "检测到编译器: C=%s, C++=%s" c-compiler c++-compiler)))
  
  ;; 修复 flymake-cc 在 c++-ts-mode 下的报错问题
  (defun my-flymake-cc-c++-setup ()
    "设置 C++ 的 flymake 配置。"
    (my-setup-c-compiler-flags)
    (setq-local flymake-cc-command flymake-cc-c++-command))
  
  (defun my-flymake-cc-c-setup ()
    "设置 C 的 flymake 配置。"
    (my-setup-c-compiler-flags))
  
  ;; 添加 hook
  (add-hook 'c-mode-hook #'my-flymake-cc-c-setup)
  (add-hook 'c-ts-mode-hook #'my-flymake-cc-c-setup)
  (add-hook 'c++-mode-hook #'my-flymake-cc-c++-setup)
  (add-hook 'c++-ts-mode-hook #'my-flymake-cc-c++-setup))

;; ----------------------------------------------------------------------------
;; Eglot LSP 配置增强
;; ----------------------------------------------------------------------------

(defun my-setup-eglot-for-cc ()
  "为 C/C++ 设置增强的 Eglot 配置。"
  (when (featurep 'eglot)
    ;; 根据平台设置 clangd 参数
    (let ((clangd-args '("--background-index"
                         "--clang-tidy"
                         "--completion-style=detailed"
                         "--header-insertion=never"
                         "--pch-storage=memory"
                         "--cross-file-rename"
                         "--query-driver=**/*")))
      
      ;; Windows 特定配置
      ;; 注意: --target 不是 clangd 有效 CLI 参数，目标平台应在
      ;; eglot-workspace-configuration 的 :fallbackFlags 中配置
      (when (eq system-type 'windows-nt)
        (setq clangd-args (append clangd-args
                                  '("--compile-commands-dir=."))))
      
      ;; Linux/macOS 配置
      (when (memq system-type '(gnu/linux darwin))
        (setq clangd-args (append clangd-args
                                  '("--compile-commands-dir=build"))))
      
      ;; 更新 eglot 服务器配置 (使用 add-to-list 避免重复)
      (add-to-list 'eglot-server-programs `((c-mode c-ts-mode) . ("clangd" ,@clangd-args)))
      (add-to-list 'eglot-server-programs `((c++-mode c++-ts-mode) . ("clangd" ,@clangd-args)))

      ;; 设置工作区配置
      (setq-default eglot-workspace-configuration
                    '((:clangd . (:completion (:placeholder :json-false)
                                   :fallbackFlags ["-std=c++17" "-Wall" "-Wextra" "-Wpedantic"])))))
      ))

;; 延迟加载 Eglot 配置
(with-eval-after-load 'eglot
  (my-setup-eglot-for-cc))

;; ----------------------------------------------------------------------------
;; 编译系统配置
;; ----------------------------------------------------------------------------

(defun my-compile-cc-project ()
  "智能编译 C/C++ 项目。"
  (interactive)
  (let ((default-directory (or (project-root (project-current)) default-directory))
        (compile-command nil))
    
    ;; 检测构建系统
    (cond
     ((file-exists-p "CMakeLists.txt")
      (if (file-exists-p "build")
          (setq compile-command "cd build && cmake --build .")
        (setq compile-command "mkdir -p build && cd build && cmake .. && cmake --build .")))
     ((file-exists-p "Makefile")
      (setq compile-command "make"))
     ((file-exists-p "meson.build")
      (if (file-exists-p "build")
          (setq compile-command "cd build && ninja")
        (setq compile-command "meson setup build && cd build && ninja")))
     (t
      ;; 简单单文件编译
      (let ((file (buffer-file-name))
            (compiler (my-detect-c++-compiler)))
        (when file
          (cond
           ((string-match "\\.c\\'" file)
            (setq compile-command (format "%s -Wall -Wextra -std=c17 -o %s %s"
                                          (my-detect-c-compiler)
                                          (file-name-sans-extension file)
                                          file)))
           ((string-match "\\.cpp\\'" file)
            (setq compile-command (format "%s -Wall -Wextra -std=c++17 -o %s %s"
                                          compiler
                                          (file-name-sans-extension file)
                                          file))))))))
    
    (if compile-command
        (compile compile-command)
      (call-interactively 'compile))))

;; ----------------------------------------------------------------------------
;; 调试配置
;; ----------------------------------------------------------------------------

(use-package gdb-mi
  :ensure nil
  :config
  (setq gdb-many-windows t
        gdb-show-main t
        gdb-display-io-nopopup t))

;; ----------------------------------------------------------------------------
;; 工具函数
;; ----------------------------------------------------------------------------

(defun my-check-cc-tools ()
  "检查 C/C++ 开发工具是否安装。"
  (interactive)
  (let ((missing-tools '())
        (available-tools '()))
    
    ;; 检查编译器
    (dolist (tool '("gcc" "g++" "clang" "clang++" "cl" "make" "cmake" "gdb" "lldb"))
      (if (executable-find tool)
          (push tool available-tools)
        (push tool missing-tools)))
    
    ;; 仅在有缺失工具时显示警告
    (when missing-tools
      (message "⚠️  缺失 C/C++ 工具: %s" (string-join missing-tools ", ")))

    (unless (executable-find "clangd")
      (message "⚠️  clangd 未安装，建议安装以获得更好的代码补全体验"))))

;; ----------------------------------------------------------------------------
;; 快捷键绑定
;; ----------------------------------------------------------------------------

(defun my-setup-cc-keybindings ()
  "设置 C/C++ 特定快捷键。"
  (local-set-key (kbd "C-c C-c") 'my-compile-cc-project)
  (local-set-key (kbd "C-c C-t") 'my-check-cc-tools)
  (local-set-key (kbd "C-c C-d") 'gdb)
  
  ;; SPC 本地 leader 键
  (general-define-key
   :keymaps '(c-mode-map c-ts-mode-map c++-mode-map c++-ts-mode-map)
   :prefix ","
   "c" 'my-compile-cc-project
   "t" 'my-check-cc-tools
   "d" 'gdb
   "f" 'eglot-format
   "r" 'eglot-rename
   "a" 'eglot-code-actions))

;; 添加 hook
(add-hook 'c-mode-hook 'my-setup-cc-keybindings)
(add-hook 'c-ts-mode-hook 'my-setup-cc-keybindings)
(add-hook 'c++-mode-hook 'my-setup-cc-keybindings)
(add-hook 'c++-ts-mode-hook 'my-setup-cc-keybindings)

;; 启动时检查工具
(add-hook 'emacs-startup-hook 'my-check-cc-tools)

(provide 'lang-cc)
;;; lang-cc.el ends here