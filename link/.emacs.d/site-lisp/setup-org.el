(require 'org)

(set-face-attribute 'org-level-1 nil :inherit 'outline-3)
(set-face-attribute 'org-level-3 nil :inherit 'outline-6)
(set-face-attribute 'org-level-6 nil :inherit 'outline-1)

(use-package stripe-buffer
  :ensure t
  :config
  (add-hook 'org-mode-hook 'turn-on-stripe-table-mode)
  )

(add-hook 'org-mode-hook 'visual-line-mode)

(provide 'setup-org)
