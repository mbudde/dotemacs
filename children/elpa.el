(require 'package)
(package-initialize)

;; Workaround for bug in the ELPA package for yaml-mode
(autoload 'yaml-mode "yaml-mode" "" t)