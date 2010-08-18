(add-to-list 'load-path "~/.emacs.d/support/ergoemacs/ergoemacs/ergoemacs-keybindings")
(add-to-list 'load-path "~/.emacs.d/support/ergoemacs/packages")

(setenv "ERGOEMACS_KEYBOARD_LAYOUT" "da")

(require 'ergoemacs-mode)
(ergoemacs-mode 1)
