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

(defun my/vterm-skip-claude-rename (orig-fn title)
  "Don't let vterm rename claude-code-ide buffers."
  (unless (string-prefix-p "*claude-code[" (buffer-name))
    (funcall orig-fn title)))

(advice-add 'vterm--set-title :around #'my/vterm-skip-claude-rename)

(provide 'setup-ai)
