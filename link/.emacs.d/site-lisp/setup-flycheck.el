(use-package flycheck
  :hook (after-init . global-flycheck-mode))

(use-package flycheck-irony
  :after flycheck
  :hook (flycheck-mode . flycheck-irony-setup))

(use-package consult-flycheck
  :after (consult flycheck))

(provide 'setup-flycheck)
