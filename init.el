;; Package Dependencies:
;; Required:
;;   linum:     http://stud4.tuwien.ac.at/~e0225855/linum/linum.html
;; Optional:
;;   emacs-goodies-el (color-theme)
;;   slime:     http://common-lisp.net/project/slime/
;;   yasnippet: http://code.google.com/p/yasnippet/
;;   org-mode:  git://repo.or.cz/org-mode.git
;;   jd-el:     git://git.naquadah.org/~jd/jd-el.git
;;   magit:     git://github.com/philjackson/magit.git
;;   edit-server http://github.com/stsquad/emacs_chrome

;; Bugs:
;; * Error when emacs is started in ~/Documents/Org

;; ---------------------------------------------------------
;; load-paths

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/library")
(add-to-list 'load-path "~/.emacs.d/support")

;; ---------------------------------------------------------
;; Faces and color theme
;; Must be executed before some of the other stuff or I get an
;; "arithmetic error".

(custom-set-faces
 '(default ((t (:inherit nil :stipple nil :background "#000000" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

(require 'color-theme-subdued nil 'noerror)

(add-hook 'after-make-frame-functions
          (lambda (frame)
            (set-variable 'color-theme-is-global nil)
            (select-frame frame)
            (if (and window-system (fboundp 'color-theme-subdued-light))
                (color-theme-subdued-light)
              (color-theme-standard))))

;; ---------------------------------------------------------
;; Load configuration files

(prefer-coding-system 'utf-8)

(load-library "dotemacs")
(setq dotemacs-children-prefix "~/.emacs.d/children/")
(dotemacs-load-children
 '("functions"
   "ergoemacs"
   "options"
   "mode-hooks"
   "org-mode"
   "ido-mode"
   "magit"
   "yasnippet"
   "sml-mode"
   "vala-mode"
   "whitespace-mode"
   "zwiebel"
   "linum"
   "other"
   "keybinding"
   "elpa"))


(put 'narrow-to-region 'disabled nil)
