(use-package yasnippet
  :commands (yas-minor-mode) ; autoload `yasnippet' when `yas-minor-mode' is called
                                        ; using any means: via a hook or by user
  :init ; stuff to do before requiring the package
  (progn
    (add-hook 'prog-mode-hook #'yas-minor-mode))
  :config ; stuff to do after requiring the package
  (progn
    (yas-reload-all)))

(use-package yasnippet-snippets)

(provide 'setup-yasnippet)
