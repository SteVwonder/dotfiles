(use-package elpy
  :ensure t
  :init (elpy-enable)
  )

(use-package blacken
  :ensure t
  :config
  (setq blacken-only-if-project-is-blackened t)
  )

(setq python-fill-docstring-style 'django)

(provide 'setup-pydev)
