(add-to-list 'load-path "~/.emacs.d/support/yasnippet")

(require 'yasnippet)

(yas/initialize)
(setq yas/root-directory
      '("~/.emacs.d/snippets"
        "~/.emacs.d/support/yasnippet/snippets"))
(mapcar 'yas/load-directory yas/root-directory)
(add-to-list 'hippie-expand-try-functions-list 'yas/hippie-try-expand) ;; Expand snippets with hippie expand

(setq yas/prompt-functions
      '(yas/ido-prompt yas/x-prompt yas/dropdown-prompt
        yas/completing-prompt yas/no-prompt))
