(provide 'dotemacs)

(require 'cl)

(setq dotemacs-loaded-ok t)

(defun dotemacs-display-status (status)
  (if status
      (propertize "OK" 'face "compilation-info")
    (propertize "ERROR" 'face "compilation-error")))

(defun dotemacs-load-children (dotemacs-children-list)
  (with-current-buffer (get-buffer-create "*Dotemacs Status*")
    (toggle-read-only -1)
    (insert "Dotemacs package load status: \n\n")
    (mapc (lambda(x)
	    (condition-case err-message
		(unwind-protect
		    (load (concat dotemacs-children-prefix x ".el"))
		  (insert (format "[%s] Finished loading file: %s\n" (dotemacs-display-status t) x)))
	      (error (progn
		      (insert (format "[%s] Unable to load file: %s - %s\n" (dotemacs-display-status nil) x err-message))
		      (setq dotemacs-loaded-ok nil))))) dotemacs-children-list)
    (toggle-read-only t)))
