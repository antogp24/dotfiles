;; Completion
;; --------------------------------------------------------------------------------------------------------------------- ;; 

(use-package company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 3)
(setq company-backends (delete 'company-semantic company-backends))
(define-key c-mode-map  [(tab)] 'company-complete)
(define-key c++-mode-map  [(tab)] 'company-complete)

;; Syntax Highlighting
;; --------------------------------------------------------------------------------------------------------------------- ;; 
(use-package tree-sitter)
(use-package tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; C/C++ config

(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))

(defun anto/compilation-hook ()
  (make-local-variable 'truncate-lines)
  (setq truncate-lines nil))

(add-hook 'compilation-mode-hook 'anto/compilation-hook)

(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p anto/makescript) t
      (cd "../")
      (find-project-directory-recursive)))

(defun lock-compilation-directory ()
  "The compilation process should NOT hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked t)
  (message "Compilation directory is locked."))

(defun unlock-compilation-directory ()
  "The compilation process SHOULD hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked nil)
  (message "Compilation directory is roaming."))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory (concat default-directory "../")) ;; NOTE: Look back a directory
  (switch-to-buffer-other-window "*compilation*")
  (if compilation-directory-locked (cd last-compilation-directory)
    (cd find-project-from-directory)
    (find-project-directory-recursive)
    (setq last-compilation-directory default-directory)))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (if (find-project-directory) (compile anto/makescript))
  (other-window 1))

(defun run-without-asking ()
  "Make the current build."
  (interactive)
  (if (find-project-directory) (compile anto/runscript))
  (other-window 1))

(defun clean-without-asking ()
  "Make the current build."
  (interactive)
  (if (find-project-directory) (compile anto/cleanscript))
  (other-window 1))

(define-key c-mode-map (kbd "M-m") 'make-without-asking)
(define-key c-mode-map (kbd "M-.") 'run-without-asking)
(define-key c-mode-map (kbd "M-n") 'clean-without-asking)

(defun cproject (dirname)
  "Open all C/C++ files in a directory"
  (interactive "D")
  (mapc #'find-file (directory-files-recursively dirname "\\.c$" nil))
  (mapc #'find-file (directory-files-recursively dirname "\\.h$" nil)))

(defun anto/c-hook ()

  ;; Space tabs
  (setq c-default-style "linux"
	c-basic-offset anto/tab-width)
  (setq tab-width anto/tab-width
        indent-tabs-mode nil)
  
  ;; No hungry backspace
  (c-toggle-auto-hungry-state -1)

  ;; Semi-colon doesn't indent
  (setq c-hanging-semi&comma-criteria '((lambda () 'stop)))

  ;; Enable Autocompletion
  (setq dabbrev-case-replace t)
  (setq dabbrev-case-fold-search t)
  (setq dabbrev-upcase-means-case-search t)
  (electric-pair-mode 1)
  (abbrev-mode 1)
)

(add-hook 'c-mode-common-hook 'anto/c-hook)
(add-hook 'c-mode-hook        'anto/c-hook)
(add-hook 'c++-mode-hook      'anto/c-hook)

;; Python

(defun python-run-main ()
  (interactive)
  (async-shell-command "python main.py"))

(add-hook 'python-mode-hook (lambda () (local-set-key (kbd "M-.") 'python-run-main)))
