;; theme from https://github.com/Gavinok/emacs.d
(add-to-list 'custom-theme-load-path (concat user-emacs-directory "lisp/spaceway/"))

(add-to-list 'default-frame-alist '(background-color . "#000000"))
(require 'frame)
(defun set-cursor-hook (frame)
(modify-frame-parameters
  frame (list (cons 'cursor-color "#dc322f"))))
(add-hook 'after-make-frame-functions 'set-cursor-hook)

(set-cursor-color "#dc322f")
(load-theme 'spaceway t)

(use-package highlight-numbers
  :hook (c-mode-hook c-mode-common-hook python-mode-hook c++-mode-hook)
  :config
  (modify-face 'highlight-numbers-number "#9FDDD2" nil nil nil nil nil nil nil))

(add-hook 'c-mode-common-hook 'highlight-numbers-mode)
(add-hook 'c-mode-hook 'highlight-numbers-mode)
(add-hook 'python-mode-hook 'highlight-numbers-mode)
(add-hook 'c++-mode-hook 'highlight-numbers-mode)
