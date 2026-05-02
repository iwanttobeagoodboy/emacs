;;; mod-org.el --- 完美映射 GTD 五步工作流与动态归档 -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 0. 动态路径声明与目录初始化 (核心改动)
;; ──────────────────────────────────────────────────────
(defvar my-org-dir (expand-file-name "org/" user-emacs-directory)
  "GTD 系统的根目录，随 Emacs 配置一起漫游")

;; 防御性编程：如果目录不存在，自动创建它
(unless (file-exists-p my-org-dir)
  (make-directory my-org-dir t))

;; ──────────────────────────────────────────────────────
;; 1. 基础设定与任务状态流转
;; ──────────────────────────────────────────────────────
(use-package org
  :ensure nil
  :defer t
  :custom
  (org-directory my-org-dir)
  ;; 动态拼接核心文件路径
  (org-agenda-files (list (expand-file-name "inbox.org" my-org-dir)
                          (expand-file-name "todo.org" my-org-dir)))
  
  ;; 定义任务状态的生命周期
  (org-todo-keywords
   '((sequence "IDEA(i)" "TODO(t)" "DOING(n)" "WAITING(w)" "|" "DONE(d)" "CANCEL(c)")))
  
  ;; 外观与日志记录
  (org-hide-leading-stars t)
  (org-startup-indented t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  
  :config
  ;; 将核心按键注入全局 Leader 菜单
  (my-leader-def
    "n c" 'org-capture         
    "o a" 'org-agenda))        

;; ──────────────────────────────────────────────────────
;; 2. 第 1 步：闪电记录想法 (Capture)
;; ──────────────────────────────────────────────────────
(with-eval-after-load 'org
  ;; 注意：这里使用了反引号 (`) 和逗号 (,) 来允许路径被动态计算
  (setq org-capture-templates
        `(("i" "💡 闪电想法/未分配任务 [Inbox]" entry 
           (file ,(expand-file-name "inbox.org" my-org-dir))
           "* IDEA %?\n  记录于: %U\n  来源: %a\n" 
           :empty-lines 1)))) 

;; ──────────────────────────────────────────────────────
;; 3. 第 2 & 3 步：周期处理与移动 (Refile)
;; ──────────────────────────────────────────────────────
(with-eval-after-load 'org
  (setq org-refile-targets '((org-agenda-files :maxlevel . 2)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)

  (define-key org-mode-map (kbd "C-c C-w") 'org-refile))

;; ──────────────────────────────────────────────────────
;; 4. 第 4 步：按年月动态多级文件夹归档 (Archive)
;; ──────────────────────────────────────────────────────
(with-eval-after-load 'org
  (defun my/org-archive-by-date (orig-fun &rest args)
    "拦截默认的归档动作，将文件存入按年/月生成的动态目录中。"
    (let* ((year (format-time-string "%Y"))
           (month (format-time-string "%m"))
           ;; 这里的 org-directory 已经变成了你自定义的 my-org-dir
           (archive-dir (expand-file-name (format "archive/%s/%s/" year month) org-directory))
           (org-archive-location (concat archive-dir "%s_archive::* 历史归档")))
      
      (unless (file-exists-p archive-dir)
        (make-directory archive-dir t))
      
      (apply orig-fun args)))

  (advice-add 'org-archive-subtree :around #'my/org-archive-by-date)
  (define-key org-mode-map (kbd "C-c C-x C-a") 'org-archive-subtree))

;; ──────────────────────────────────────────────────────
;; 5. 第 5 步：周期性复盘查看 (Agenda & Super-Agenda)
;; ──────────────────────────────────────────────────────
(use-package org-super-agenda
  :after org
  :config
  (org-super-agenda-mode 1)
  (setq org-agenda-custom-commands
        '(("r" "🔄 周期性复盘看板 (Inbox 清理 & 进度回顾)"
           ((agenda "" 
                    ((org-agenda-span 'week)
                     (org-agenda-start-on-weekday 1) 
                     (org-agenda-show-log t)         
                     (org-agenda-log-mode-items '(closed state)) 
                     (org-super-agenda-groups
                      '((:name "✅ 本周已完成 (成就复盘)" :log t)
                        (:name "📅 日程提醒与死线" :time-grid t :deadline t)
                        (:discard (:anything t))))))
            (alltodo "" 
                     ((org-super-agenda-groups
                       '((:name "📥 第一步：待处理的原始想法 (Inbox)" :file-path "inbox")
                         (:name "🚀 第二步：当前正在推进 (Doing)" :todo "DOING")
                         (:name "⏳ 第三步：待处理任务堆积 (Todo)" :todo "TODO")
                         (:name "⏸️ 阻塞/等待外部反馈 (Waiting)" :todo "WAITING")
                         (:discard (:anything t)))))))))))

(provide 'mod-org)
;;; mod-org.el ends here