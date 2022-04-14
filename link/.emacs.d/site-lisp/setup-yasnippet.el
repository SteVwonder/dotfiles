(use-package yasnippet-snippets
  :ensure t
  )

(use-package yasnippet
  :ensure t
  :init
  (yas-reload-all)
  (yas-global-mode)
  )

(provide 'setup-yasnippet)
