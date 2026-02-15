;;; setup-completion.el --- Minibuffer & in-buffer completion -*- lexical-binding: t; -*-

;; --- Minibuffer completion stack ---

(use-package vertico
  :init
  (vertico-mode)
  :bind (:map vertico-map
              ("C-l" . vertico-directory-up))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-x b"   . consult-buffer)
         ("M-y"     . consult-yank-pop)
         ("M-s l"   . consult-line)
         ("M-s r"   . consult-ripgrep)
         ("M-g g"   . consult-goto-line)
         ("M-g M-g" . consult-goto-line))
  :config
  (setq consult-narrow-key "<"))

(use-package embark
  :bind (("C-."   . embark-act)
         ("C-;"   . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; --- In-buffer completion ---

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  :init
  (global-corfu-mode))

(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))

(provide 'setup-completion)
;;; setup-completion.el ends here
