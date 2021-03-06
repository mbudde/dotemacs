
(add-to-list 'load-path "~/.emacs.d/support/org-mode/lisp")

(require 'org-install)

(setq org-modules
      '(org-docview
        org-info
        org-jsinfo
        org-habit
        org-timer))

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(setq org-directory "~/Documents/Org"
      org-agenda-files (list org-directory)
      org-default-notes-file "notes.org"
      org-hide-leading-stars t
      org-agenda-ndays 7
      org-deadline-warning-days 14
      org-agenda-use-time-grid nil
      org-agenda-show-all-dates t
      org-agenda-skip-deadline-if-done t
      org-agenda-skip-scheduled-if-done t
      org-agenda-start-on-weekday nil
      org-clock-idle-time 15
      org-fast-tag-selection-single-key 'expert)

(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s)"
                  "WAITING(w@)" "APPT(a)" "|"
                  "DONE(d!)" "DEFERRED(f@)" "CANCELLED(x@)")))

(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "#ad7fa8" :weight bold))
        ("STARTED" . (:foreground "orange" :weight bold))
        ("WAITING" . (:foreground "blue" :weight bold))
        ("CANCELLED" . (:foreground "red" :weight bold))))

(setq org-capture-templates
      '(("t" "TODO" entry
         (file+headline "todo.org" "Tasks")
         "* TODO %?")
        ("u" "Urgent" entry
         (file+headline "todo.org" "Tasks")
         "* TODO %?\n  SCHEDULED: %t")
        ("n" "Note" entry
         (file+headline "notes.org" "Notes")
         "* %u %?" :prepend t)
        ("v" "ViewWorld" entry
         (file "viewworld.org")
         "* TODO %?" :prepend t)))

(setq org-agenda-custom-commands
      '(("u" alltodo ""
         ((org-agenda-skip-function
           (lambda nil (org-agenda-skip-entry-if 'scheduled 'deadline)))
          (org-agenda-overriding-header "Unscheduled TODO entries: ")))))
