(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("M-p" . projectile-command-map))
  :config
  (setq projectile-indexing-method 'alien)
  )

(use-package helm-projectile)

(use-package projectile-ripgrep)

(provide 'setup-projectile)
