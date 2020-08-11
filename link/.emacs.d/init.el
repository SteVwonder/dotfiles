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
  (package-install 'use-package)
  ;; fetch the list of packages available
  (unless package-archive-contents
    (package-refresh-contents))
  )



(add-hook 'c-mode-hook
          (lambda()
            (local-unset-key (kbd "C-c C-c"))))

(eval-when-compile
  (require 'use-package))
(require 'bind-key)

;; refactoring goodness
(use-package iedit
  :ensure t
  :bind ("C-c ;" . iedit-mode)
)

(use-package win-switch
  :ensure t
  :config (global-set-key "\C-xo" 'win-switch-mode)
  (global-set-key "\C-xn" 'win-switch-next-window)
  (global-set-key "\C-xp" 'win-switch-previous-window)
  (win-switch-add-key "n" 'next-window)
  (setq win-switch-other-window-first nil)
  (setq win-switch-idle-time 1.25)
  )

(require 'setup-org)
(require 'setup-company)
(require 'setup-helm)
(require 'setup-irony)
(require 'setup-flycheck)
(require 'setup-gnuplot)
(require 'setup-misc)
(require 'setup-langtool)
(require 'setup-tex)
(require 'setup-pydev)
(require 'setup-coding-modes)
(require 'setup-projectile)
(require 'setup-linklings-mode)

(load-theme 'herbein t)
(enable-theme 'herbein)

;; If running in emacsclient, force a prompt before exiting client
(defun my-save-buffers-kill-terminal ()
  (if (frame-parameter nil 'client)
      (if (yes-or-no-p "Really exit this Emacsclient? ")
          (save-buffers-kill-terminal nil)
        )
    (save-buffers-kill-terminal nil)
    )
  )
(global-set-key (kbd "C-x C-c")
                (lambda () (interactive) (my-save-buffers-kill-terminal)))

(provide 'init)
;;; init.el ends here
