;; complete anything goodness
(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-backends (delete 'company-semantic company-backends))
  (eval-after-load "shell"
    '(define-key shell-mode-map (kbd "TAB") #'company-complete))
  (add-hook 'shell-mode-hook #'company-mode)
)

(use-package jedi
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :init (add-hook 'python-mode-hook 'jedi:setup)
  )

(use-package company-jedi
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :init (add-to-list 'company-backends 'company-jedi)
  )

(use-package company-web
  :ensure t
)

(provide 'setup-company)
