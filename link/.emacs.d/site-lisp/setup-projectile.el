(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("M-p" . projectile-command-map))
  :config
  (setq projectile-indexing-method 'alien)
  )

(use-package projectile-git-autofetch
  :ensure t
  :after projectile
  :config
  (projectile-git-autofetch-mode 1))

(provide 'setup-projectile)
