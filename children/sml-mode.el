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
            
