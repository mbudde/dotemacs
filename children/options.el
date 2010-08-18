;; General settings

(setq user-full-name "Michael Budde"
      user-mail-address "mbudde@gmail.com")

(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-right-scroll-bar)
(show-paren-mode 1)
(column-number-mode 1)

;; Use a bar cursor instead of a block when available
(when (fboundp 'bar-cursor-mode)
  (bar-cursor-mode 1))

(setq inhibit-startup-message t)
(setq diff-switches "-u")               ;; Default to unified diff
(setq c-default-style '((c-mode . "k&r")))

;; Don't pollute my folders with backup files
(setq make-backup-files nil
      auto-save-default nil)

(setq-default indent-tabs-mode nil
              tab-width 4
              c-basic-offset 4)

;; Don't wrap lines by default
(setq-default truncate-lines 1)

;; Sensible copy-paste behaviour
(setq mouse-drag-copy-region nil
      x-select-enable-primary nil
      x-select-enable-clipboard t)

;; Scroll one line at a time with mouse (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(2 ((shift) . 10)) ; one line at a time
      mouse-wheel-progressive-speed nil             ; don't accelerate scrolling
      mouse-wheel-follow-mouse 't)                  ; scroll window under mouse

;; http://trey-jackson.blogspot.com/2007/12/emacs-tip-5-hippie-expand.html
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(setq inferior-lisp-program "clisp")

;; Auto-mode
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
