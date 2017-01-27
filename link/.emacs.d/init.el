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
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("elpa" . "http://tromey.com/elpa/")
        ("melpa-stable" . "http://stable.melpa.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ))
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install the missing packages
(unless (package-installed-p 'use-package)
        (package-install 'use-package))

(require 'use-package)

;; refactoring goodness
(use-package iedit
  :ensure t
  :bind ("C-c ;" . iedit-mode)
)

(use-package magit
  :ensure t
  :init (setq magit-last-seen-setup-instructions "1.4.0")
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

(use-package w3m
  :ensure t
  :config
  ;;change default browser for 'browse-url'  to w3m
  (setq browse-url-browser-function 'w3m-goto-url-new-session)
  ;;change w3m user-agent to android
  (setq w3m-user-agent "Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.")
)

(require 'setup-org)
(require 'setup-company)
(require 'setup-helm)
(require 'setup-tex)
(require 'setup-irony)
(require 'setup-flycheck)
(require 'setup-misc)
(require 'setup-langtool)

(load-theme 'herbein t)
(enable-theme 'herbein)
