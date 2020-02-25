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

(provide 'setup-coding-modes)
