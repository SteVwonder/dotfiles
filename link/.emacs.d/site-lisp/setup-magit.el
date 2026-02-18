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

(use-package magit-gerrit
  :after magit
  :config
  ;; Name of your Gerrit remote, e.g. "gerrit" or "origin"
  (setq-default magit-gerrit-remote "gerrit")
  ;; Usually you want to push for review (refs/for/...)
  (setq-default magit-gerrit-push-to 'for)
  )

(provide 'setup-magit)
