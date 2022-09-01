(defun setup-commit-mode ()
  ;; setup git commit mode
  ;; turns on auto fill and sets fill column
  (turn-on-auto-fill)
  (setq fill-column 72))

(use-package magit
  :init
  (setq magit-last-seen-setup-instructions "1.4.0")
  :config
  (dolist (regexp '("^Bad passphrase, try again for .*: ?$"
                    "^Enter passphrase for .*: ?$"))
    (add-to-list 'magit-process-password-prompt-regexps regexp))
  (add-hook 'git-commit-mode-hook #'setup-commit-mode)
  )

(use-package undo-tree
  :config (global-undo-tree-mode)
  ;; Prevent undo tree files from polluting your git repo
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  )

(use-package vlf)

(use-package vdiff)

(use-package transpose-frame)

(use-package academic-phrases)

(use-package whitespace
  :init
  (global-whitespace-mode t)
  :config
  (setq whitespace-line-column 100)
  (setq whitespace-style (quote (face trailing lines-tail)))
  (setq whitespace-global-modes (quote (not org-mode latex-mode LaTeX-mode)))
  :hook
  (rust-mode . (lambda () (setq whitespace-line-column 100)))
  )

(use-package buffer-move)

(use-package vs-dark-theme)

(use-package vs-light-theme)

(use-package win-switch
  :config (global-set-key "\C-xo" 'win-switch-mode)
  (global-set-key "\C-xn" 'win-switch-next-window)
  (global-set-key "\C-xp" 'win-switch-previous-window)
  (win-switch-add-key "n" 'next-window)
  (setq win-switch-other-window-first nil)
  (setq win-switch-idle-time 1.25)
  )

;; refactoring goodness
(use-package iedit
  :bind ("C-c ;" . iedit-mode)
)

(use-package perspective
  :bind
  ;;("C-x C-b" . persp-list-buffers)   ; or use a nicer switcher, see below
  :init
  (persp-mode)
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))
  )


(use-package vterm
  :config
  (add-to-list 'vterm-eval-cmds '("update-pwd" (lambda (path) (setq default-directory path))))
  )

(provide 'setup-misc)
