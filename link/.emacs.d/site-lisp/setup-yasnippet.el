(use-package yasnippet-snippets
  :ensure t
  )

(use-package yasnippet
  :ensure t
  :init
  (yas-reload-all)
  (add-hook 'python-mode-hook 'yas-minor-mode)
  )

(provide 'setup-yasnippet)
