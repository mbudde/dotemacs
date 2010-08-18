;; ---------------------------------------------------------
;; Global keybindings

(global-set-key (kbd "<f5>") (lambda () (interactive) (revert-buffer nil t)))
(global-set-key (kbd "<f6>") 'linum-mode)
(global-set-key (kbd "<f7>") 'toggle-truncate-lines)
(global-set-key (kbd "<f8>") 'toggle-show-trailing-whitespace-show-ws)
(global-set-key (kbd "<f9>") 'toggle-subdued-light-theme)
(global-set-key (kbd "C-h") 'beginning-of-line-text)
(global-set-key (kbd "C-j") 'newline-and-indent)
(global-set-key (kbd "C-,") 'comment-or-uncomment-current-line-or-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "M-m") 'transpose-chars)
(global-set-key (kbd "C-c d") 'copy-line-contents)
(global-set-key (kbd "C-c j") 'new-indented-line)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c C-c") 'eval-buffer)
(global-set-key (kbd "C-M-æ") 'isearch-forward-regexp)
(global-set-key (kbd "C-M-Æ") 'isearch-backward-regexp)
(global-set-key (kbd "s-!") 'kill-buffer-and-window)

(when (featurep 'org-install)
  (global-set-key (kbd "C-r") 'org-capture)
  (global-set-key (kbd "C-c a") 'org-agenda))

;; ------------------------------------
;; Minor mode for override key bindings

(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

(define-key my-keys-minor-mode-map (kbd "M-e") 'my-backward-kill-word)
(define-key my-keys-minor-mode-map (kbd "M-r") 'my-forward-kill-word)

(define-minor-mode my-keys-minor-mode
  "A minor -mode so that my key settings override annoying major modes."
  t nil 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)