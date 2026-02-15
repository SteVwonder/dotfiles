
(use-package flycheck
  :init (global-flycheck-mode)
  )

(use-package flycheck-irony
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
  )

(use-package consult-flycheck)

(provide 'setup-flycheck)
