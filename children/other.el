;; Slime
(when (require 'slime-autoloads nil 'noerror)
  (slime-setup))

;; Winner mode (undo window changes)
(when (fboundp 'winner-mode)
  (winner-mode 1))

;; Ledger mode
(require 'mbledger nil 'noerror)

;; Rainbow mode and Google Maps from jd-el
(add-to-list 'load-path "~/.emacs.d/support/rainbow")
(require 'rainbow-mode nil 'noerror)
(require 'google-maps nil 'noerror)

;; edit-server
(when (require 'edit-server nil 'noerror)
  (setq edit-server-new-frame nil)
  (edit-server-start))

(require 'smooth-scrolling nil 'noerror)

(require 'emacsd-tile)

(require 'redo)

(require 'tramp)

(add-to-list 'load-path "~/.emacs.d/support/smex")
(when (require 'smex nil 'noerror)
  (smex-initialize))

(require 'php-mode)

(when (featurep 'yaml-mode)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode)))

(when (require 'csharp-mode nil 'noerror)
  (add-to-list 'auto-mode-alist '("\\.cs$" . csharp-mode)))

(when (require 'xquery-mode nil 'noerror)
  (add-to-list 'auto-mode-alist '("\\.xql$" . xquery-mode)))

(require 'color-theme-solarized nil 'noerror)
