(setq site-lisp-dir (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path site-lisp-dir)

;; Load custom settings
(setq custom-file "~/.emacs.d/LOCAL-custom.el")
(load custom-file 'noerror)

;; Package management goodness
(require 'setup-package)

;; Setup "general" emacs settings
(require 'setup-general)

;; Uncomment to benchmark startup
;;(require 'benchmark-init)
;;(add-hook 'after-init-hook 'benchmark-init/deactivate)

(eval-when-compile
  (require 'use-package)
  (require 'use-package-ensure)
  (setq use-package-always-ensure t)
  )
(require 'bind-key)

(require 'setup-helm)

(require 'setup-coding-modes)
(require 'setup-flycheck)
(require 'setup-misc)
(require 'setup-org)
(require 'setup-projectile)
(require 'setup-lsp)
(require 'setup-company)
;;(require 'setup-yasnippet)
;;(require 'setup-langtool)
;;(require 'setup-linklings-mode)
;;(require 'setup-tex)

;;(load-theme 'herbein t)
;;(enable-theme 'herbein)

(provide 'init)
;;; init.el ends here
