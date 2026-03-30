(use-package dtrt-indent
  :hook (after-init . dtrt-indent-global-mode))

(add-hook 'prog-mode-hook 'visual-line-mode)

(add-hook 'c-mode-hook
          (lambda()
            (local-unset-key (kbd "C-c C-c"))))

;;(use-package rust-mode)

(use-package toml-mode :defer t)

;; Org Babel — set before org loads so it picks up the languages
(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (emacs-lisp . t)
     (shell . t)
     (awk . t)
     (org . t))))

(use-package json-mode :defer t)

(use-package go-mode :defer t)

;; Copied from https://gist.github.com/robfig/5975784
;; Modifed to only set gofmt-command, rather than hook
(with-eval-after-load 'go-mode
  (when (executable-find "goimports")
    (setq gofmt-command "goimports")
    (setq gofmt-args '("-local" "go.corp.nvidia.com"))))

;; Comment out to prevent conflict with lsp-mode
;; (add-hook 'go-mode-hook
;;          (lambda ()
;;            (add-hook 'before-save-hook 'gofmt-before-save nil t)))

(use-package cython-mode :defer t)

(use-package lua-mode :defer t)

(use-package yaml-mode :defer t)

(use-package markdown-mode
  :hook ((markdown-mode . (lambda () (electric-indent-local-mode -1)))
         (markdown-mode . visual-line-mode)))

(use-package adoc-mode
  :defer t
  :mode "\\.adoc\\'")

(use-package python-black
  :after python)

(setq python-fill-docstring-style 'django)

(use-package which-key
  :hook (after-init . which-key-mode))

(use-package protobuf-mode :defer t)

(use-package cue-mode
  :defer t
  :hook (cue-mode . (lambda () (add-hook 'before-save-hook 'cue-reformat-buffer nil t))))

(use-package bazel :defer t)

(use-package dockerfile-mode :defer t)

(use-package docker-compose-mode :defer t)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :hook (after-init . global-treesit-auto-mode)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all))

(use-package markdown-preview-mode :defer t)

;; Syntax highlighting etc for django development
;; (use-package nXhtml)
;; (use-package django-mode
;;   :init (add-to-list 'auto-mode-alist '("\\.djhtml$" . django-html-mode))
;;   )

;; (use-package easy-hugo
;;   :init
;;   (setq easy-hugo-basedir "~/Repositories/stevwonder.github.io/stevwonder/")
;;   (setq easy-hugo-previewtime "300")
;;   :bind ("C-c C-e" . easy-hugo))

(use-package groovy-mode :defer t)
(use-package jenkinsfile-mode :defer t)

(use-package terraform-mode
  :defer t
  :custom (terraform-format-on-save t))

(use-package ini-mode :defer t)

(use-package jsonnet-mode :defer t)

(use-package lsp-pyright
  :ensure t
  :defer t
  :init
  ;; Load before lsp-deferred fires (priority -90) so pyright's client is registered
  (add-hook 'python-mode-hook (lambda () (require 'lsp-pyright)) -90)
  (add-hook 'python-ts-mode-hook (lambda () (require 'lsp-pyright)) -90)
  :custom (lsp-pyright-langserver-command "pyright"))

(provide 'setup-coding-modes)
