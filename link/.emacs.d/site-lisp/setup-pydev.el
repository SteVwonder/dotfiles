(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(use-package python-black
  :demand t
  :after python
  )

(setq python-fill-docstring-style 'django)

(provide 'setup-pydev)
