(use-package magit
  :ensure t
  :init
  (setq magit-last-seen-setup-instructions "1.4.0")
  :config
  (dolist (regexp '("^Bad passphrase, try again for .*: ?$"
                    "^Enter passphrase for .*: ?$"))
    (add-to-list 'magit-process-password-prompt-regexps regexp))
  )

(use-package undo-tree
  :ensure t
  :config (global-undo-tree-mode)
  )

(use-package vlf
  :ensure t
  )

(use-package lua-mode
  :ensure t
  )

(use-package vdiff
  :ensure t
  )

(use-package transpose-frame
  :ensure t
  )

(provide 'setup-misc)
