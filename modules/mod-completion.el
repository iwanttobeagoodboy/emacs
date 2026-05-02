;;; mod-completion.el --- 现代补全前端与项目管理 -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 1. Vertico: 极简的垂直补全菜单 (替代默认的网格补全)
;; ──────────────────────────────────────────────────────
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)) ; 允许菜单向下/向上循环滚动

;; ──────────────────────────────────────────────────────
;; 2. Orderless: 强大的乱序模糊搜索
;; ──────────────────────────────────────────────────────
;; 作用：输入 "config el" 就能匹配 "config-init.el"，无视顺序
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; ──────────────────────────────────────────────────────
;; 3. Consult: 极其强大的搜索增强 (支持实时预览)
;; ──────────────────────────────────────────────────────
(use-package consult
  :bind (("C-s" . consult-line)      ; 替代原生搜索，右侧分屏显示所有匹配项
         ("M-y" . consult-yank-pop)  ; 剪贴板历史浏览与搜索
         ("C-x b". consult-buffer))) ; 增强版缓冲区切换，支持按类型过滤

;; ──────────────────────────────────────────────────────
;; 4. Marginalia: Minibuffer 的“详情增强器” (注解支持)
;; ──────────────────────────────────────────────────────
;; 作用：在候选项右侧以灰色字体显示文件大小、命令文档、快捷键绑定等
(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle)) ; 循环切换注解信息的详细程度
  :init
  (marginalia-mode))

;; ──────────────────────────────────────────────────────
;; 5. Embark: Minibuffer 的“右键动作菜单”
;; ──────────────────────────────────────────────────────
;; 作用：光标悬停在任何补全项上，按 C-. 即可触发针对该目标的动作操作
(use-package embark
  :bind
  (("C-." . embark-act)         ; 核心触发键
   ("C-h B" . embark-bindings)) ; 替代默认的快捷键列表，展示更清晰
  :init
  ;; 用 Embark 接管前缀键的帮助提示 (比如按 C-x 等一会儿弹出的提示)
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; 执行完动作后自动关闭 minibuffer，保持界面专注
  (setq embark-quit-after-action t))

;; ──────────────────────────────────────────────────────
;; 6. Embark-Consult: 整合胶水层
;; ──────────────────────────────────────────────────────
;; 作用：让 Embark 正确识别并处理 Consult 生成的搜索结果
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; ──────────────────────────────────────────────────────
;; 7. Projectile: 项目管理神器
;; ──────────────────────────────────────────────────────
(use-package projectile
  :init
  (projectile-mode +1)
  :custom
  (projectile-project-search-path '("d:/code/"))
  (projectile-auto-discover t)
  :config
  ;; 将 Projectile 挂载到我们在 core-keybinds 中定义的 C-c p 菜单下
  (my-leader-def
    "p p" 'projectile-switch-project
    "p f" 'projectile-find-file
    "p s" 'consult-ripgrep           ; 项目内全文极速搜索 (依赖系统级 ripgrep)
    "p k" 'projectile-kill-buffers)) ; 一键关闭当前项目打开的所有 buffer

(provide 'mod-completion)
;;; mod-completion.el ends here
