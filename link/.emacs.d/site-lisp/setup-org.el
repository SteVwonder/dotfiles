(with-eval-after-load 'org
  (set-face-attribute 'org-level-1 nil :inherit 'outline-3)
  (set-face-attribute 'org-level-3 nil :inherit 'outline-6)
  (set-face-attribute 'org-level-6 nil :inherit 'outline-1))

(use-package stripe-buffer
  :defer t
  :hook (org-mode . turn-on-stripe-table-mode))

(add-hook 'org-mode-hook 'visual-line-mode)

(provide 'setup-org)
