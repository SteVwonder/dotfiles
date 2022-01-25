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

(use-package rust-mode
  :ensure t)

(use-package toml-mode
  :ensure t)

;; Org Babel
(setq
 org-babel-load-languages
 '((python . t)
   (emacs-lisp . t)
   (shell . t)
   (awk . t)
   (org . t)
   ))

(use-package json-mode
  :ensure t)

(use-package go-mode
  :ensure t)

;; Copied from https://gist.github.com/robfig/5975784
;; Modifed to only set gofmt-command, rather than hook
(dolist (path exec-path)
  (when (file-exists-p (concat path "/goimports"))
    (setq gofmt-command "goimports")
     (setq gofmt-args (quote ("-local" "git.nvda.ai")))
    ))

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save nil t)))

(provide 'setup-coding-modes)
