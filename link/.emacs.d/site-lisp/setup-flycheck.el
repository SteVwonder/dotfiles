(defun my/disable-flycheck-in-go-buffer ()
  "Disable Flycheck in Go buffers.

The standard Go checkers do not understand our Bazel monorepo layout well
enough to provide useful diagnostics."
  (flycheck-mode -1))

(use-package flycheck
  :hook ((after-init . global-flycheck-mode)
         (go-mode . my/disable-flycheck-in-go-buffer)
         (go-ts-mode . my/disable-flycheck-in-go-buffer)))

(use-package flycheck-irony
  :after flycheck
  :hook (flycheck-mode . flycheck-irony-setup))

(use-package consult-flycheck
  :after (consult flycheck))

(provide 'setup-flycheck)
