;;; early-init.el --- 启动性能优化与首帧防闪屏 -*- lexical-binding: t -*-

;; ──────────────────────────────────────────────────────
;; 1. 垃圾回收阈值临时调高
;; ──────────────────────────────────────────────────────
;; 启动过程中会执行大量配置，将 GC 内存阈值临时拉高到 100 MB，
;; 能大幅减少反复垃圾回收带来的卡顿，显著加快启动速度。
;; 该值在 init.el 末尾会被恢复为正常值（例如 16 MB）。
(setq gc-cons-threshold (* 100 1024 1024))

;; ──────────────────────────────────────────────────────
;; 2. 首帧显示压制（防闪屏核心）
;; ──────────────────────────────────────────────────────
;; 下面的设置必须在 Emacs 创建第一个图形窗口之前完成，
;; 否则会先用默认样式显示窗口，再切换到我们的配置，造成视觉闪烁。

;; 隐藏菜单栏 (0 行)
(push '(menu-bar-lines . 0) default-frame-alist)

;; 隐藏工具栏 (0 行)
(push '(tool-bar-lines . 0) default-frame-alist)

;; 隐藏滚动条 (传入 nil 代表完全禁用)
(push '(vertical-scroll-bars . nil) default-frame-alist)

;; 默认字体：JetBrainsMono Nerd Font，CJK 回退到 Sarasa
(push '(font . "JetBrainsMono NF-13") default-frame-alist)

;; 彻底关闭原生 tooltip（鼠标悬停提示），用 echo area 替代，防止弹窗卡顿
(tooltip-mode -1)

;; ──────────────────────────────────────────────────────
;; 3. 其他影响首帧行为的选项
;; ──────────────────────────────────────────────────────

;; 禁止 Emacs 在用户调整窗口时不自动改变窗口大小，避免启动时窗口尺寸抖动
(setq frame-inhibit-implied-resize t)

;; 禁止弹出文件选择对话框（统一用 minibuffer 键盘操作）
(setq use-dialog-box nil)

;; 关闭 Emacs 启动时的欢迎画面
(setq inhibit-startup-screen t)

;; ──────────────────────────────────────────────────────
;; 4. 包管理接管
;; ──────────────────────────────────────────────────────
;; 禁用 Emacs 默认的包自动加载机制，
;; 我们将在 init.el 中通过 use-package 和懒加载手动接管，保障启动速度。
(setq package-enable-at-startup nil)

;;; early-init.el ends here
