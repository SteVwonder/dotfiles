(use-package elpy
  :ensure t
  :init (elpy-enable)
  )

(use-package blacken
  :ensure t
  :config
  (setq blacken-only-if-project-is-blackened t)
  (add-hook 'python-mode-hook 'blacken-mode)
  )

(setq python-fill-docstring-style 'django)

(provide 'setup-pydev)
