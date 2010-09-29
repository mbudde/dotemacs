
(require 'whitespace)

(setq whitespace-line-column 80
      whitespace-style '(tabs trailing lines-tail))

(add-hook 'sml-mode-hook 'whitespace-mode)
(add-hook 'python-mode-hook 'whitespace-mode)