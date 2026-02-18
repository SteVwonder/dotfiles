(setq site-lisp-dir (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path site-lisp-dir)
(add-to-list 'load-path (expand-file-name "vendor" site-lisp-dir))

(when (display-graphic-p)
  (tool-bar-mode -1))

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

(let ((init-features '("setup-completion" "setup-coding-modes" "setup-flycheck" "setup-magit" "setup-misc"
                       "setup-org" "setup-projectile" "setup-lsp"
                       "setup-ai"
                       ;;"setup-langtool" "setup-linklings-mode" "setup-tex"
                       )))
  (mapc #'load init-features)
  )

(provide 'init)
;;; init.el ends here
