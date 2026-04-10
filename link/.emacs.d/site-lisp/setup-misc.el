(use-package undo-tree
  :hook (after-init . global-undo-tree-mode)
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(use-package vlf :defer t)

(use-package vdiff :defer t)

(use-package transpose-frame :defer t)

(use-package academic-phrases :defer t)

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

(use-package buffer-move :defer t)

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


(use-package vterm
  :bind (:map vterm-mode-map
              ("C-c C-v" . vterm-copy-mode)
              ("C-c C-e" . vterm-send-escape)
              ("C-q" . vterm-send-next-key)
         :map vterm-copy-mode-map
              ("C-c C-v" . vterm-copy-mode))
  :config
  (add-to-list 'vterm-eval-cmds '("update-pwd" (lambda (path) (setq default-directory path))))
  (setq vterm-buffer-name-string "vterm %s")
  (setq vterm-shell (or (getenv "SHELL") "/bin/bash"))

  (defun my/strip-trailing-whitespace-from-kill (&rest _)
    "Strip trailing whitespace from the latest kill ring entry when in vterm."
    (when (and kill-ring (derived-mode-p 'vterm-mode))
      (setcar kill-ring
              (replace-regexp-in-string "[ \t]+$" "" (car kill-ring)))))

  (advice-add 'kill-new :after #'my/strip-trailing-whitespace-from-kill)
  )

(require 'multi-scratch)

(use-package avy
  :bind ("M-g w" . 'avy-goto-word-1)
  ("M-g c" . 'avy-goto-char)
  )

(when (getenv "SSH_CONNECTION")
  (setq interprogram-cut-function
        (lambda (text)
          (let ((process-connection-type nil))
            (let ((proc (start-process "lemonade-copy" nil "lemonade" "copy")))
              (process-send-string proc text)
              (process-send-eof proc)))))
  (setq interprogram-paste-function
        (lambda ()
          (let ((output (shell-command-to-string "lemonade paste")))
            (unless (string-empty-p output) output)))))

(use-package wgrep
  :ensure t
  )

(use-package rainbow-csv
  :ensure t
  :straight (rainbow-csv
             :type git
             :host github
             :repo "emacs-vs/rainbow-csv")
  :hook ((csv-mode . rainbow-csv-mode)
         (tsv-mode . rainbow-csv-mode))
  )

(setq browse-url-browser-function 'browse-url-generic)
(if (getenv "SSH_CONNECTION")
    (setq browse-url-generic-program "lemonade"
          browse-url-generic-args '("open"))
  (setq browse-url-generic-program "open"))

(provide 'setup-misc)
