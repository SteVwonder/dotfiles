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

(use-package company-web
  :ensure t
)

(provide 'setup-company)
