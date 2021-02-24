(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  (setq elpy-rpc-python-command "python3")
  )

(use-package python-black
  :demand t
  :after python
  )

(setq python-fill-docstring-style 'django)

(provide 'setup-pydev)
