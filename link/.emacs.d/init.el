(setq site-lisp-dir (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path site-lisp-dir)
(add-to-list 'load-path (expand-file-name "vendor" site-lisp-dir))

;; Load custom settings
(setq custom-file "~/.emacs.d/LOCAL-custom.el")
(load custom-file 'noerror)

;; Package management goodness
;;(require 'setup-package)
(load (concat site-lisp-dir "/setup-straight.el"))

;; Setup "general" emacs settings
(require 'setup-general)

;; Uncomment to benchmark startup
;; (require 'benchmark-init)
;; (add-hook 'after-init-hook 'benchmark-init/deactivate)

(require 'bind-key)

(let ((init-features '("setup-helm" "setup-coding-modes" "setup-flycheck" "setup-misc"
                       "setup-org" "setup-projectile" "setup-lsp" "setup-company"
                       ;;"setup-yasnippet" "setup-langtool" "setup-linklings-mode" "setup-tex"
                       )))
  (mapc #'load init-features)
  )

(provide 'init)
;;; init.el ends here
