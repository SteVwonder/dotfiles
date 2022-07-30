
(use-package flycheck
  :init (global-flycheck-mode)
  )

(use-package flycheck-irony
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
  )

(use-package helm-flycheck)

(provide 'setup-flycheck)
