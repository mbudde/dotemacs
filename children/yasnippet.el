(add-to-list 'load-path "~/.emacs.d/support/yasnippet")

(require 'yasnippet)

(yas/initialize)
(setq yas/root-directory
      '("~/.emacs.d/snippets"
        "~/.emacs.d/support/yasnippet/snippets"))
(mapcar 'yas/load-directory yas/root-directory)
(add-to-list 'hippie-expand-try-functions-list 'yas/hippie-try-expand) ;; Expand snippets with hippie expand
