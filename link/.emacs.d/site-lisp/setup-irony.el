
(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  )

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(use-package company-irony
  :ensure t
  :config
  (add-to-list 'company-backends '(company-irony))
  (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  )

(use-package company-irony-c-headers
  :ensure t
  :config (add-to-list 'company-backends '(company-irony-c-headers))
  )

(provide 'setup-irony)
