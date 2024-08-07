(defun setup-commit-mode ()
  ;; setup git commit mode
  ;; turns on auto fill and sets fill column
  (turn-on-auto-fill)
  (setq fill-column 72))

(use-package magit
  :init
  (setq magit-last-seen-setup-instructions "1.4.0")
  :config
  (dolist (regexp '("^Bad passphrase, try again for .*: ?$"
                    "^Enter passphrase for .*: ?$"))
    (add-to-list 'magit-process-password-prompt-regexps regexp))
  (add-hook 'git-commit-mode-hook #'setup-commit-mode)
  )

(defun get-branch-sha (branch)
  (let ((repo (magit-toplevel)))
    (when repo
      (with-temp-buffer
        (cd repo)
        (magit-git-insert "rev-parse" branch)
        (string-trim (buffer-string)))))
  )

(defun get-current-branch-sha ()
  "Get the SHA of the current branch in the Git repository."
  (get-branch-sha "HEAD")
  )

(defun get-gerrit-link (branch)
  "Generate a Gerrit link for the current file and line number.
   BRANCH specifies the Git branch to use in the link.
   If BRANCH is an empty string, 'main' is used as the default."
   (concat
    "https://git-av.nvidia.com/r/plugins/gitiles/maglev/+/"
    branch
    "/"
    (file-relative-name buffer-file-name (projectile-project-root))
    "#"
    (number-to-string (line-number-at-pos))
    )
  )

(defun gerrit-link-current-branch-sha ()
  "Generate a Gerrit link for the current file, line number, and current git branch SHA."
  (interactive)
  (clipetty-cut 'kill-new (get-gerrit-link (get-current-branch-sha)))
  )

(defun gerrit-link (branch)
  "Adds to the kill ring a Gerrit link for the current file and line number.
   Interactive function.
   BRANCH specifies the Git branch to use in the link.
   If BRANCH is an empty string, 'main' is used as the default."
  (interactive (list (read-string "Enter the Git branch name (default: main): " "main")))
  (clipetty-cut 'kill-new (get-gerrit-link
             (if (not (string-equal branch "main")) (get-branch-sha branch) "main")
             ))
  )

(use-package undo-tree
  :config (global-undo-tree-mode)
  ;; Prevent undo tree files from polluting your git repo
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  )

(use-package vlf)

(use-package vdiff)

(use-package transpose-frame)

(use-package academic-phrases)

(use-package whitespace
  :init
  (global-whitespace-mode t)
  :config
  (setq whitespace-line-column 100)
  (setq whitespace-style (quote (face trailing lines-tail)))
  (setq whitespace-global-modes (quote (not org-mode latex-mode LaTeX-mode)))
  :hook
  (rust-mode . (lambda () (setq whitespace-line-column 100)))
  )

(use-package buffer-move)

(when (eq system-type 'darwin)
  (use-package vs-dark-theme)
  (use-package auto-dark
    :init
    (setq auto-dark-light-theme 'herbein)
    (setq auto-dark-dark-theme 'vs-dark)
    (auto-dark-mode t)
    )
  )

(use-package win-switch
  :config (global-set-key "\C-xo" 'win-switch-mode)
  (global-set-key "\C-xn" 'win-switch-next-window)
  (global-set-key "\C-xp" 'win-switch-previous-window)
  (win-switch-add-key "n" 'next-window)
  (setq win-switch-other-window-first nil)
  (setq win-switch-idle-time 1.25)
  )

;; refactoring goodness
(use-package iedit
  :bind ("C-c ;" . iedit-mode)
)

(use-package perspective
  :bind
  ;;("C-x C-b" . persp-list-buffers)   ; or use a nicer switcher, see below
  :init
  (persp-mode)
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))
  )


(use-package vterm
  :config
  (add-to-list 'vterm-eval-cmds '("update-pwd" (lambda (path) (setq default-directory path))))
  (setq vterm-buffer-name-string "vterm %s")
  )

(require 'multi-scratch)

(use-package avy
  :bind ("M-g w" . 'avy-goto-word-1)
  ("M-g c" . 'avy-goto-char)
  )

(straight-use-package
 '(clipetty
   :type git
   :host github
   :repo "spudlyo/clipetty"
   :fork t
   )
 )

(use-package clipetty
  :ensure t
  :bind ("M-w" . clipetty-kill-ring-save)
  )

(provide 'setup-misc)
