(use-package undo-tree
  :config (global-undo-tree-mode)
  ;; Prevent undo tree files from polluting your git repo
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  )

(use-package vlf)

(use-package vdiff)

(use-package transpose-frame)

(use-package academic-phrases)

(use-package whitespace
  :init
  (global-whitespace-mode t)
  :config
  (setq whitespace-line-column 100)
  (setq whitespace-style (quote (face trailing lines-tail)))
  (setq whitespace-global-modes (quote (not org-mode latex-mode LaTeX-mode)))
  :hook
  (rust-mode . (lambda () (setq whitespace-line-column 100)))
  )

(use-package buffer-move)

(use-package doom-themes
  :ensure t
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; for treemacs users
  ;; (doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  :config
  (load-theme 'doom-ayu-mirage t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; (when (eq system-type 'darwin)
;;   (use-package vs-dark-theme)
;;   (use-package auto-dark
;;     :init
;;     (setq auto-dark-light-theme 'herbein)
;;     (setq auto-dark-dark-theme 'vs-dark)
;;     (auto-dark-mode t)
;;     )
;;   )

(use-package win-switch
  :config (global-set-key "\C-xo" 'win-switch-mode)
  (global-set-key "\C-xn" 'win-switch-next-window)
  (global-set-key "\C-xp" 'win-switch-previous-window)
  (win-switch-add-key "n" 'next-window)
  (setq win-switch-other-window-first nil)
  (setq win-switch-idle-time 1.25)
  )

;; refactoring goodness
(use-package iedit
  :bind ("C-c ;" . iedit-mode)
)

(use-package perspective
  :bind
  ;;("C-x C-b" . persp-list-buffers)   ; or use a nicer switcher, see below
  :init
  (persp-mode)
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))
  )


(use-package vterm
  :config
  (add-to-list 'vterm-eval-cmds '("update-pwd" (lambda (path) (setq default-directory path))))
  (setq vterm-buffer-name-string "vterm %s")
  )

(require 'multi-scratch)

(use-package avy
  :bind ("M-g w" . 'avy-goto-word-1)
  ("M-g c" . 'avy-goto-char)
  )

(straight-use-package
 '(clipetty
   :type git
   :host github
   :repo "spudlyo/clipetty"
   :fork t
   )
 )

(use-package clipetty
  :ensure t
  :init (global-clipetty-mode)
  :bind ("M-w" . clipetty-kill-ring-save)
  )

(use-package wgrep
  :ensure t
  )

(provide 'setup-misc)
