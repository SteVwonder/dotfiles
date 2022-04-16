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
  ;; Prevent undo tree files from polluting your git repo
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
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
  :hook
  (rust-mode . (lambda () (setq whitespace-line-column 100)))
  )

(use-package buffer-move
  :ensure t)

(use-package vs-dark-theme
  :ensure t)

(use-package vs-light-theme
  :ensure t)

(use-package win-switch
  :ensure t
  :config (global-set-key "\C-xo" 'win-switch-mode)
  (global-set-key "\C-xn" 'win-switch-next-window)
  (global-set-key "\C-xp" 'win-switch-previous-window)
  (win-switch-add-key "n" 'next-window)
  (setq win-switch-other-window-first nil)
  (setq win-switch-idle-time 1.25)
  )

;; refactoring goodness
(use-package iedit
  :ensure t
  :bind ("C-c ;" . iedit-mode)
)

(provide 'setup-misc)
