(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if
  ;; neither, we use the current indent-tabs-mode
  (let ((space-count (how-many "^  " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))

(add-hook 'c-mode-common-hook 'infer-indentation-style)
(add-hook 'c-special-indent-hook 'infer-indentation-style)
(add-hook 'python-mode-hook 'infer-indentation-style)

(add-hook 'c-mode-hook
          (lambda()
            (local-unset-key (kbd "C-c C-c"))))

(use-package rust-mode)

(use-package toml-mode)

;; Org Babel
(setq
 org-babel-load-languages
 '((python . t)
   (emacs-lisp . t)
   (shell . t)
   (awk . t)
   (org . t)
   ))

(use-package json-mode)

(use-package go-mode)

;; Copied from https://gist.github.com/robfig/5975784
;; Modifed to only set gofmt-command, rather than hook
(dolist (path exec-path)
  (when (file-exists-p (concat path "/goimports"))
    (setq gofmt-command "goimports")
     (setq gofmt-args (quote ("-local" "go.corp.nvidia.com")))
    ))

;; Comment out to prevent conflict with lsp-mode
;; (add-hook 'go-mode-hook
;;          (lambda ()
;;            (add-hook 'before-save-hook 'gofmt-before-save nil t)))

(defun lsp-go-install-save-hooks ()
  "Set up before-save hooks to format buffer and add/delete imports.
Make sure you don't have other gofmt/goimports hooks enabled."
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(use-package cmake-mode)

(use-package cython-mode)

(use-package lua-mode)

(use-package yaml-mode)

(use-package markdown-mode)

(use-package adoc-mode
  :init (add-to-list 'auto-mode-alist (cons "\\.adoc\\'" 'adoc-mode))
  )

; (use-package lsp-pyright
;   
;   :hook (python-mode . (lambda ()
;                           (require 'lsp-pyright)
;                           (lsp))))  ; or lsp-deferred
; (use-package lsp-python-ms
;   
;   :init (setq lsp-python-ms-auto-install-server t))

(use-package python-black
  :demand t
  :after python
  )

(setq python-fill-docstring-style 'django)

;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l", "s-l")
(setq lsp-keymap-prefix "C-c l")
(use-package lsp-mode
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         ;; (XXX-mode . lsp)
         (rust-mode . lsp)
         (go-mode . lsp)
         (go-mode . lsp-go-install-save-hooks)
         ; (python-mode . (lambda ()
         ;                  (require 'lsp-python-ms)
         ;                  (lsp)))
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-go-directory-filters ["-bazel-out" "-bazel-bin" "-bazel-main" "-bazel-development" "-bazel-testlogs" "-node_modules"])
  (setq lsp-file-watch-ignored-directories (append '("bazel-out" "bazel-bin" "bazel-main" "bazel-testlogs" "third_party") lsp-file-watch-ignored-directories))
  (setq lsp-enable-file-watchers nil)
  ; (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  :commands lsp
  )

;; optionally
(use-package lsp-ui
  :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp
  :commands helm-lsp-workspace-symbol)
;; if you are ivy user
;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
  :config
  (which-key-mode))

;; The default setting is too low for lsp-mode’s needs due to the fact that
;; client/server communication generates a lot of memory/garbage.
(setq gc-cons-threshold 100000000)

;; Increase the amount of data which Emacs reads from the process. Again the
;; emacs default is too low 4k considering that the some of the language server
;; responses are in 800k - 3M range.
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(use-package protobuf-mode)

(use-package cue-mode
  :config
  (add-hook 'before-save-hook 'cue-reformat-buffer nil t)
  )

(use-package bazel)

(use-package dockerfile-mode)

(use-package docker-compose-mode)

(use-package tree-sitter
  :hook (tree-sitter-after-on-hook. tree-sitter-hl-mode)
  :init (global-tree-sitter-mode)
  )
(use-package tree-sitter-langs)

(use-package markdown-preview-mode)

(provide 'setup-coding-modes)
