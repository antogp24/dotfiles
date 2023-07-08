;; BETTER COMMENTS!!!
(setq anto/regular-modes '(c++-mode c-mode python-mode emacs-lisp-mode compilation-mode))

(make-face 'font-lock-fixme-face)
(make-face 'font-lock-note-face)
(make-face 'font-lock-username-face)
(make-face 'font-lock-compilation-face)
(make-face 'font-lock-makescript-face)
(make-face 'font-lock-runscript-face)
(make-face 'font-lock-cleanscript-face)

(mapc (lambda (mode)
	(font-lock-add-keywords
	 mode
	 '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
	   ("\\<\\(FIXME\\)" 1 'font-lock-fixme-face t)
           ("\\<\\(NOTE\\)" 1 'font-lock-note-face t)
	   ("\\<\\(anto\\)" 1 'font-lock-username-face t)
	   )))
      anto/regular-modes)

(font-lock-add-keywords
    '(compilation-mode)
    '(("\\<\\(compilation\\)" 1 'font-lock-compilation-face t)
      ("\\<\\(build.bat\\)" 1 'font-lock-makescript-face t)
      ("\\<\\(run.bat\\)"   1 'font-lock-runscript-face t)
      ("\\<\\(clean.bat\\)" 1 'font-lock-cleanscript-face t)
))
(modify-face 'font-lock-fixme-face "firebrick1"          nil nil t nil t nil nil)
(modify-face 'font-lock-note-face "Light blue"           nil nil t nil t nil nil)
(modify-face 'font-lock-username-face "Light Yellow"     nil nil t nil nil nil nil)
(modify-face 'font-lock-compilation-face "DarkOrange1"   nil nil nil nil nil nil nil)
(modify-face 'font-lock-makescript-face "MediumOrchid1"  nil nil t nil t t nil)
(modify-face 'font-lock-runscript-face "goldenrod1"      nil nil t nil t t nil)
(modify-face 'font-lock-cleanscript-face "brown1"        nil nil t nil t t nil)

;; NOTE: REPLACE STRINGS WITH UNICODE CHARACTERS

(defun anto/load-prettify-symbols ()
  (interactive)
  (setq prettify-symbols-alist '(
				("->"  . ?→)
				("=>"  . ?⇒)
				("<="  . ?≤)
				(">="  . ?≥)
				("[-]" . ?•)
))

  ;; NOTE(anto): This big-ass function enables
  ;;             prettify on comments and strings.
   (setq prettify-symbols-compose-predicate
        (defun anto/prettify-symbols-default-compose-p (start end _match)
          "Same as `prettify-symbols-default-compose-p', except compose symbols in comments as well."
          (let* ((syntaxes-beg (if (memq (char-syntax (char-after start)) '(?w ?_))
                                   '(?w ?_) '(?. ?\\)))
                 (syntaxes-end (if (memq (char-syntax (char-before end)) '(?w ?_))
                                   '(?w ?_) '(?. ?\\))))
            (not (or (memq (char-syntax (or (char-before start) ?\s)) syntaxes-beg)
                     (memq (char-syntax (or (char-after end) ?\s)) syntaxes-end)
                     (nth 3 (syntax-ppss)))))))
   
   ;; NOTE(anto): This enables it, but only on
   ;;             the specified hooks.
   (prettify-symbols-mode 1))

(add-hook 'c-mode-common-hook 'anto/load-prettify-symbols)
