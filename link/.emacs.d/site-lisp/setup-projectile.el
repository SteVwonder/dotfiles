(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("M-p" . projectile-command-map))
  :config
  (setq projectile-indexing-method 'alien)
  )

(define-key minibuffer-local-map (kbd "<up>") 'previous-complete-history-element)
(define-key minibuffer-local-map (kbd "<down>") 'next-complete-history-element)

(use-package helm-projectile)

(use-package projectile-ripgrep)

(provide 'setup-projectile)
