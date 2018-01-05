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

(use-package nlinum
  :ensure t
  :config (global-nlinum-mode 1)
  (setq nlinum-highlight-current-line t)
  (setq nlinum-format "%d|")
  (set-face-attribute 'nlinum-current-line nil :inherit 'linum :foreground "yellow" :weight 'bold)
  )

(provide 'setup-misc)
