(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  :bind
  ("C-c c" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup)
  :init
  (setq claude-code-ide-terminal-backend 'vterm)
  (setq claude-code-ide-window-width 150)
  )

(provide 'setup-ai)
