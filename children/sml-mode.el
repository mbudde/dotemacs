(add-to-list 'load-path "~/.emacs.d/support/sml-mode")

(require 'sml-mode)

(add-to-list 'auto-mode-alist '("\\.sml$" . sml-mode))
(add-to-list 'auto-mode-alist '("\\.sig$" . sml-mode))

(setq sml-program-name "mosml"
      sml-default-arg "-P full"
      sml-indent-level 2)

(add-hook 'sml-mode-hook
 (lambda ()
   (setq words-include-escape t)))     ; \ loses word break status

(defun sml-find-prev-fun ()
  (interactive)
  (save-excursion
    (when (search-backward-regexp "fun \\((.*?) \\)?\\([[:digit:][:word:]!%&$#+-/:<=>?@\\~`^|*_']+\\)" nil t)
      (match-string 2))))

(defvar sml-test-font-lock-keywords
  '(("val test.*= \\(true\\)" 1 'compilation-info)
    ("val \\(test.*\\) = \\(false\\)" (1 'compilation-error) (2 'compilation-error)))
  "Font-lock keywords for SML-Test mode")

(define-minor-mode sml-test-mode
  "Highlight test results in Inferior SML shell"
  :lighter " SMLTest"
  (if sml-test-mode
      (font-lock-add-keywords nil sml-test-font-lock-keywords)
    (font-lock-remove-keywords nil sml-test-font-lock-keywords)))

(add-hook 'inferior-sml-mode-hook
 (lambda ()
   (sml-test-mode)))
