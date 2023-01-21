;;
;; LSP-Mode
;;

(defun lsp-go-install-save-hooks ()
  "Set up before-save hooks to format buffer and add/delete imports.
Make sure you don't have other gofmt/goimports hooks enabled."
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l", "s-l")
(setq lsp-keymap-prefix "C-c l")
(use-package lsp-mode
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         ;; (XXX-mode . lsp)
         (rust-mode . lsp)
         (go-mode . lsp)
         (go-mode . lsp-go-install-save-hooks)
         (python-mode . lsp)
         ; (python-mode . (lambda ()
         ;                  (require 'lsp-python-ms)
         ;                  (lsp)))
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-go-directory-filters ["-bazel-out" "-bazel-bin" "-bazel-main" "-bazel-development" "-bazel-testlogs" "-node_modules"])
  (setq lsp-file-watch-ignored-directories (append '("bazel-out" "bazel-bin" "bazel-main" "bazel-testlogs" "third_party") lsp-file-watch-ignored-directories))
  (setq lsp-enable-file-watchers nil)
  (setq lsp-pylsp-plugins-yapf-enabled t)
  (setq lsp-pylsp-plugins-rope-completion-enabled t)
  ; (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  :commands lsp
  )

;; ;; optionally
(use-package lsp-ui
   :commands lsp-ui-mode)
;; ;; if you are helm user
 (use-package helm-lsp
   :commands helm-lsp-workspace-symbol)
;; if you are ivy user
;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; The default setting is too low for lsp-mode’s needs due to the fact that
;; client/server communication generates a lot of memory/garbage.
(setq gc-cons-threshold 100000000)

;; Increase the amount of data which Emacs reads from the process. Again the
;; emacs default is too low 4k considering that the some of the language server
;; responses are in 800k - 3M range.
(setq read-process-output-max (* 1024 1024)) ;; 1mb

; (use-package lsp-pyright
;   
;   :hook (python-mode . (lambda ()
;                           (require 'lsp-pyright)
;                           (lsp))))  ; or lsp-deferred
; (use-package lsp-python-ms
;   
;   :init (setq lsp-python-ms-auto-install-server t))

(provide 'setup-lsp)
