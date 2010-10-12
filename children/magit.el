;; Magit
(add-to-list 'load-path "~/.emacs.d/support/magit")
(require 'magit)

(defun magit-commit-fixup (commit)
  (interactive "sCommit: ")
  (insert "fixup! "
          (magit-git-string "log" "-1" "--format=%s" commit)))

(defun magit-commit-squash (commit)
  (interactive "sCommit: ")
  (insert "squash! "
          (magit-git-string "log" "-1" "--format=%s" commit)))

(add-hook 'magit-log-edit-mode-hook
  (lambda ()
    (define-key magit-log-edit-mode-map (kbd "C-c f") 'magit-commit-fixup)
    (define-key magit-log-edit-mode-map (kbd "C-c s") 'magit-commit-squash)))
