
(defun anto/modes-keybindings ()
  (define-key isearch-mode-map (kbd "<up>") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "<down>") 'isearch-repeat-forward)
  (define-key isearch-mode-map (kbd "<left>") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "<right>") 'isearch-repeat-forward)
  (define-key isearch-mode-map (kbd "C-p") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "C-n") 'isearch-repeat-forward)    
)
(anto/modes-keybindings)

(defvar anto/key-map
  (let ((map (make-sparse-keymap)))
    (global-set-key (kbd "C-v") 'yank)
    (global-set-key (kbd "C-,") 'other-window)
    (global-set-key (kbd "M-,") 'other-window)
    (global-set-key (kbd "C-z") 'undo)
    (global-set-key (kbd "C-y") 'undo-redo)
    (global-set-key (kbd "M-k") 'ido-kill-buffer)
    (global-set-key (kbd "C-s") 'save-buffer)
    (global-set-key (kbd "M-0") 'delete-window)
    (global-set-key (kbd "M-1") 'delete-other-windows)
    (global-set-key (kbd "M-2") 'split-window-below)
    (global-set-key (kbd "M-3") 'split-window-right)
    (global-set-key (kbd "M-;") 'View-back-to-mark)
    (global-set-key (kbd "S-<tab>") 'indent-region)
    (global-set-key (kbd "M-f") 'isearch-forward)
    (global-set-key (kbd "M-i") 'ido-switch-buffer)
    (global-set-key (kbd "M-o") 'ido-find-file)
    (global-set-key (kbd "M-<f4>") 'save-buffers-kill-terminal)
    (global-set-key (kbd "C-<backspace>") 'backward-kill-word)
;;    (global-set-key (kbd "C-e") 'recenter-top-bottom)
;;    (global-set-key (kbd "M-e") 'end-of-line)
;;    (global-set-key (kbd "M-w") 'beginning-of-line)
    (global-set-key (kbd "M--") 'text-scale-decrease)
    (global-set-key (kbd "M-=") 'text-scale-increase)
    (global-set-key (kbd "M-g") 'goto-line)
    (global-set-key (kbd "M-r") 'query-replace)
    (global-set-key (kbd "M-t") 'anto/shell)
    (global-set-key (kbd "C-M-;") 'anto/open-init)

    (global-set-key (kbd "C-j") 'forward-paragraph)
    (global-set-key (kbd "C-k") 'backward-paragraph)
    (global-set-key (kbd "C-h") 'left-word)
    (global-set-key (kbd "C-l") 'right-word)

    map)
  "Anto keymappings")
