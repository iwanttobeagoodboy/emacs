;;; init.el --- Emacs 配置入口 -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 1. 基础环境优化 (Emacs 30+ 特有)
;; ──────────────────────────────────────────────────────
(setq native-comp-async-report-warnings-errors 'silent)

;; ──────────────────────────────────────────────────────
;; 2. 设定模块搜索路径 (Load Path)
;; ──────────────────────────────────────────────────────
(defvar my-emacs-dir (expand-file-name user-emacs-directory))

;; 将 core 和 modules 目录加入搜索范围
(dolist (dir '("core" "modules"))
  (let ((path (expand-file-name dir my-emacs-dir)))
    (when (file-directory-p path)
      (add-to-list 'load-path path))))

;; ──────────────────────────────────────────────────────
;; 3. 隔离 Emacs 自动生成的脏代码 (Custom File)
;; ──────────────────────────────────────────────────────
(setq custom-file (expand-file-name "custom.el" my-emacs-dir))
(when (file-exists-p custom-file)
  (load custom-file 'noerror 'nomessage))

;; ──────────────────────────────────────────────────────
;; 4. 性能恢复与测速钩子 (Startup Hook)
;; ──────────────────────────────────────────────────────
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024) ; 恢复为 16MB
                  gc-cons-percentage 0.1)
            (message "🚀 Emacs 启动完毕! 耗时: %.2f 秒, 发生 %d 次 GC."
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

;; ──────────────────────────────────────────────────────
;; 5. 其他模块
;; ──────────────────────────────────────────────────────

;; --- [底层核心 Core] ---
(require 'core-packages)   ; 1. 已完成：包管理器
(require 'core-ui)         ; 2. UI、备份、UTF-8
(require 'core-keybinds)   ; 3. 快捷键配置

;; --- [业务模块 Modules] ---
(require 'mod-completion)  ; 4. 基础设施
(require 'mod-prog)        ; 5. 编程引擎
(require 'mod-git)         ; 6. Git
(require 'mod-org)         ; 7. GTD
(require 'mod-roam)          ; 8. 知识管理

;;; init.el ends here