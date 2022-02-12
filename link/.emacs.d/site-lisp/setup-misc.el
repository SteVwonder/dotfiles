(defun setup-commit-mode ()
  ;; setup git commit mode
  ;; turns on auto fill and sets fill column
  (turn-on-auto-fill)
  (setq fill-column 72))

(use-package magit
  :ensure t
  :init
  (setq magit-last-seen-setup-instructions "1.4.0")
  :config
  (dolist (regexp '("^Bad passphrase, try again for .*: ?$"
                    "^Enter passphrase for .*: ?$"))
    (add-to-list 'magit-process-password-prompt-regexps regexp))
  (add-hook 'git-commit-mode-hook #'setup-commit-mode)
  )

(use-package undo-tree
  :ensure t
  :config (global-undo-tree-mode)
  )

(use-package vlf
  :ensure t
  )

(use-package vdiff
  :ensure t
  )

(use-package transpose-frame
  :ensure t
  )

(use-package academic-phrases
  :ensure t
  )

(use-package whitespace
  :init
  (global-whitespace-mode t)
  :config
  (setq whitespace-line-column 79)
  (setq whitespace-style (quote (face trailing lines-tail)))
  (setq whitespace-global-modes (quote (not org-mode latex-mode LaTeX-mode)))
  )

(use-package buffer-move
  :ensure t)

(provide 'setup-misc)
