(add-hook 'css-mode-hook
  (lambda ()
    (setq tab-width 2)))

(add-hook 'doc-view-mode-hook
  (lambda ()
    (auto-revert-mode)))
