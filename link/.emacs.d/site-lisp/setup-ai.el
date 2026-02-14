(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  :bind
  ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup)
  :init
  (setq claude-code-ide-terminal-backend 'vterm)
  )

(provide 'setup-ai)
