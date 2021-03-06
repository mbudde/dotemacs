
(add-to-list 'load-path "~/.emacs.d/support/zwiebel")

(require 'zwiebel)

(setq zwiebel-ask-for-task nil
      zwiebel-show-seconds t
      zwiebel-work-minutes 50
      zwiebel-break-minutes 10)

(add-hook 'zwiebel-complete-hook
  (lambda ()
    (play-sound-file "~/.emacs.d/children/ding.wav")))
(add-hook 'zwiebel-break-done-hook
  (lambda ()
    (play-sound-file "~/.emacs.d/children/ding.wav")))

(when (featurep 'org-install)
  (add-hook 'org-clock-in-hook
    (lambda ()
      (when (eq *zwiebel-state* 'idle)
        (zwiebel-start '(4))))))
