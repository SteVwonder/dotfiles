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

;;(use-package rust-mode)

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

(use-package cmake-mode)

(use-package cython-mode)

(use-package lua-mode)

(use-package yaml-mode)

(use-package markdown-mode)

(use-package adoc-mode
  :init (add-to-list 'auto-mode-alist (cons "\\.adoc\\'" 'adoc-mode))
  )

(use-package python-black
  :demand t
  :after python
  )

(setq python-fill-docstring-style 'django)

;; optional if you want which-key integration
(use-package which-key
  :config
  (which-key-mode))

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

;; Syntax highlighting etc for django development
;; (use-package nXhtml)
;; (use-package django-mode
;;   :init (add-to-list 'auto-mode-alist '("\\.djhtml$" . django-html-mode))
;;   )

(use-package easy-hugo
  :init
  (setq easy-hugo-basedir "~/Repositories/stevwonder.github.io/stevwonder/")
  (setq easy-hugo-previewtime "300")
  :bind ("C-c C-e" . easy-hugo))

(use-package fish-mode)

(use-package groovy-mode)
(use-package jenkinsfile-mode)

(use-package terraform-mode
  :custom (terraform-format-on-save t)
  )

(use-package ini-mode)

(provide 'setup-coding-modes)
