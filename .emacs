(defconst anto/font "Iosevka-12")
(set-face-attribute 'default nil :font anto/font)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(defconst anto/tab-width 4)
(setq default-tab-width anto/tab-width)
(setq-default indent-tabs-mode nil)
(setq compilation-directory-locked nil)
(setq compilation-ask-about-save nil)

(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq backup-by-copying t)
(setq version-control t)
(setq kept-new-versions 6)
(setq kept-old-versions 2)
(setq delete-old-versions t)
(setq auto-save-default nil)
(setq create-lockfiles nil)

(setq scroll-margin 8)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
(global-hl-line-mode 1)

(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tooltip-mode -1)
(tool-bar-mode 0)
(menu-bar-mode -1)

(setq-default frame-resize-pixelwise t)
(setq pixel-scroll-precision-large-scroll-height 40.0)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1)
(setq scroll-conservatively 1000)
(setq next-screen-context-lines 5)
(setq line-move-visual nil)

(setq next-line-add-newlines nil)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

(define-key isearch-mode-map (kbd "C-<backspace>") 'isearch-delete-char)
(define-key isearch-mode-map (kbd "C-p") 'isearch-repeat-backward)
(define-key isearch-mode-map (kbd "C-n") 'isearch-repeat-forward)

(defun anto/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'anto/duplicate-line)

(setq use-dialog-box nil)

(setq history-length 25)
(savehist-mode 1)

(ido-mode 1)
(ido-everywhere 1)

(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")
(setq dired-mouse-drag-files t)

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

(use-package gruber-darker-theme)
(load-theme 'gruber-darker t)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)

  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-visual-state-map (kbd "C-g") 'evil-normal-state)

  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-mc
  :ensure t
  :config
  (global-evil-mc-mode 1))

(evil-define-key 'visual evil-mc-key-map
  "A" #'evil-mc-make-cursor-in-visual-selection-end
  "I" #'evil-mc-make-cursor-in-visual-selection-beg)

(evil-define-key 'normal evil-mc-key-map
  (kbd "C-g") 'evil-mc-undo-all-cursors
  (kbd "C->") 'evil-mc-make-cursor-move-next-line
  (kbd "C-<") 'evil-mc-make-cursor-move-prev-line
  (kbd "C-:") 'evil-mc-make-all-cursors
  (kbd "C-.") 'evil-mc-make-and-goto-next-match)

(setq evil-mc-always-repeat-command t)

(use-package ace-jump-mode)
(require 'ace-jump-mode)
(define-key global-map (kbd "C-;") 'ace-jump-mode)

(use-package company)
(require 'company)
(global-company-mode)

(use-package move-text)
(require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(use-package mips-mode
  :ensure t
  :mode ("\\.s\\'" . mips-mode)
  :hook (mips-mode . (lambda ()
                       (setq indent-tabs-mode nil)
                       (setq tab-width 4)
                       (electric-indent-local-mode -1))))

(add-to-list 'load-path "~/.emacs.d/my_thirdparty")
(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(defun anto/whitespace-hook ()
  (interactive)
  (whitespace-mode -1)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'c++-mode-hook 'anto/whitespace-hook)
(add-hook 'c-mode-hook 'anto/whitespace-hook)
(add-hook 'simpc-mode-hook 'anto/whitespace-hook)

(defun anto/c-open-corresponding-file ()
  "Open the corresponding source or header file in a vertical split. Handles C and C++ file extensions, assumes files are in the same directory."
  (interactive)
  (let* ((filename (buffer-file-name))
         (extension (file-name-extension filename))
         (basename (file-name-sans-extension filename))
         (source-extensions '("c" "cpp" "cc" "cxx"))
         (header-extensions '("h" "hpp" "hh" "hxx"))
         (corresponding-file nil)
         (try-extensions nil))
    (cond
     ;; If in a source file, look for headers
     ((member extension source-extensions)
      (setq try-extensions header-extensions))
     ;; If in a header file, look for sources
     ((member extension header-extensions)
      (setq try-extensions source-extensions))
     (t (message "Not a recognized C/C++ source or header file.")))

    (when try-extensions
      (let ((found nil))
        (dolist (ext try-extensions)
          (let ((try-file (concat basename "." ext)))
            (when (and (not found) (file-exists-p try-file))
              (setq corresponding-file try-file)
              (setq found t))))
        (if found
            (progn
              (split-window-right)
              (other-window 1)
              (find-file corresponding-file))
          (message "No corresponding file found."))))))

(add-hook 'c-mode-hook     (lambda () (local-set-key (kbd "C-c h") 'anto/c-open-corresponding-file)))
(add-hook 'c++-mode-hook   (lambda () (local-set-key (kbd "C-c h") 'anto/c-open-corresponding-file)))
(add-hook 'simpc-mode-hook (lambda () (local-set-key (kbd "C-c h") 'anto/c-open-corresponding-file)))


(require 'compile)
(add-to-list 'compilation-error-regexp-alist
	       '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
		 1 2 (4) (5)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ace-jump-mode company evil-collection evil-mc expand-region
                   gruber-darker-theme mips-mode move-text
                   multiple-cursors)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
