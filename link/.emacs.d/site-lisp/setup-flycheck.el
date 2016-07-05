
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  )

(use-package flycheck-irony
  :ensure t
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
  )

(use-package helm-flycheck
  :ensure t
)

(provide 'setup-flycheck)
