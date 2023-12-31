(setq undo-limit        20000000)
(setq undo-strong-limit 40000000)
(setq anto/tab-width 4)
(cd "W:/")

(add-to-list 'default-frame-alist '(font . "Iosevka-12"))
(set-face-attribute 'default t :font       "Iosevka-12")

(setq compilation-directory-locked nil)
(setq compilation-ask-about-save nil) ;; Saves Automatically
(defconst anto/makescript  "build.bat")
(defconst anto/runscript   "run.bat")
(defconst anto/cleanscript "clean.bat")

(setq backup-inhibited t)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(setq auto-save-default nil)
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
(global-hl-line-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode 0)
(menu-bar-mode -1)

(setq-default frame-resize-pixelwise t)

(setq default-tab-width anto/tab-width)

;; Smooth scrolling
(setq pixel-scroll-precision-large-scroll-height 40.0)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1)
(setq scroll-conservatively 1000)
(setq next-screen-context-lines 5)
(setq line-move-visual nil)


;; Windows Properties
(setq next-line-add-newlines nil)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)

;; Maximized on Startup
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

(defun anto/open-init()
  (interactive)
  (find-file (concat user-emacs-directory "init.el")))

(defun anto/shell()
  (interactive)
  (split-window-below -7)
  (other-window 1)
  (shell))

(load-library "view")
(require 'cc-mode)
(require 'compile)

;; NOTE(anto): PACKAGES CONFIG

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa"  . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; NOTE(anto): vim in emacs
(load (concat user-emacs-directory "lisp/vim.el"))

;; NOTE(anto): THEME CONFIG
(use-package doom-themes)
(load-theme 'doom-solarized-dark-high-contrast t)

;; NOTE(anto): Other files
(load (concat user-emacs-directory "lisp/lang-configs.el"))
(load (concat user-emacs-directory "lisp/bindings.el"))

(defun post-load-stuff ()
  (interactive)
  (maximize-frame)
)
(add-hook 'window-setup-hook 'post-load-stuff t)

;; NOTE: What the hell bro

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(tree-sitter-langs evil doom-themes company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
