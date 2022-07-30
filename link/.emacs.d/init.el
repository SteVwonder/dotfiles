(setq site-lisp-dir (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path site-lisp-dir)

;; Load custom settings
(setq custom-file "~/.emacs.d/LOCAL-custom.el")
(load custom-file 'noerror)

;; Setup "general" emacs settings
(require 'setup-general)

;; Package management goodness
(require 'package)
(setq package-archives
      '(
;;        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("elpa" . "http://tromey.com/elpa/")
;;        ("melpa-stable" . "http://stable.melpa.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ))
(package-initialize)

;; install the missing packages
(unless (package-installed-p 'use-package)
  ;; fetch the list of packages available
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install 'use-package)
  )

;; Uncomment to benchmark startup
;;(require 'benchmark-init)
;;(add-hook 'after-init-hook 'benchmark-init/deactivate)

(eval-when-compile
  (require 'use-package)
  (require 'use-package-ensure)
  (setq use-package-always-ensure t)
  )
(require 'bind-key)

(require 'setup-quelpa)
(require 'setup-yasnippet)
(require 'setup-org)
(require 'setup-company)
(require 'setup-helm)
(require 'setup-irony)
(require 'setup-flycheck)
(require 'setup-gnuplot)
(require 'setup-misc)
(require 'setup-langtool)
(require 'setup-tex)
(require 'setup-coding-modes)
(require 'setup-projectile)
(require 'setup-linklings-mode)

(load-theme 'herbein t)
(enable-theme 'herbein)

(provide 'init)
;;; init.el ends here
