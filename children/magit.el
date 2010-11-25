;; Magit
(add-to-list 'load-path "~/.emacs.d/support/magit")
(require 'magit)

(defun magit-log-1 (commit)
  (let ((args '("log" "-1" "--format=%s")))
    (if (not (eq commit nil))
        (apply 'magit-git-string (append args (list commit)))
      (apply 'magit-git-string args))))

(defun magit-commit-fixup (commit)
  (interactive "sCommit [HEAD]: ")
  (insert "fixup! " (magit-log-1 commit)))

(defun magit-commit-squash (commit)
  (interactive "sCommit [HEAD]: ")
  (insert "squash! " (magit-log-1 commit)))

(add-hook 'magit-log-edit-mode-hook
  (lambda ()
    (define-key magit-log-edit-mode-map (kbd "C-c f") 'magit-commit-fixup)
    (define-key magit-log-edit-mode-map (kbd "C-c s") 'magit-commit-squash)))
