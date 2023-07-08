
;; NOTE(anto): COMPILATION MODE

(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))

(defun anto/compilation-hook ()
  (make-local-variable 'truncate-lines)
  (setq truncate-lines nil)
)

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
  (setq find-project-from-directory (concat default-directory "../")) ;; NOTE(anto): Look back a directory
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

(global-set-key (kbd "M-m") 'make-without-asking)
(global-set-key (kbd "M-.") 'run-without-asking)
(global-set-key (kbd "M-n") 'clean-without-asking)

;; NOTE(anto): C-HOOK

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

;; NOTE(anto): PYTHON-MODE

(use-package python-mode
  :hook python-mode-hook
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq dabbrev-case-replace t)
  (setq dabbrev-case-fold-search t)
  (setq dabbrev-upcase-means-case-search t)
  (electric-pair-mode 1)
  (abbrev-mode 1)
  ;; Trash default python bindings
  (setcdr python-mode-map nil)
  (define-key python-mode-map "\t" 'dabbrev-expand))
