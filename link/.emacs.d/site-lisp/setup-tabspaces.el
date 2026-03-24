;;; setup-tabspaces.el --- Project workspaces via tabspaces -*- lexical-binding: t; -*-

(use-package tabspaces
  :hook (after-init . tabspaces-mode)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*"))
  (tabspaces-session t)
  :init
  (setq tabspaces-keymap-prefix "M-p")
  :config
  (defun my/project-open-buffers ()
    "Open magit status, a vterm, and claude-code-ide in the current project."
    (interactive)
    ;; Remove the carried-over buffer from this workspace so it
    ;; doesn't get killed when the workspace is closed
    (let ((old-buf (current-buffer)))
      (set-window-parameter (selected-window) 'quit-restore nil)
      (magit-project-status)
      (delete-other-windows)
      (save-window-excursion (vterm t))
      (set-frame-parameter nil 'buffer-list
                           (delq old-buf (frame-parameter nil 'buffer-list)))
      (claude-code-ide--start-session)))
  (setq tabspaces-project-switch-commands #'my/project-open-buffers)

  (defun my/worktree-open-in-tabspace ()
    "Create a new branch in a worktree and open it as a tabspace.
Prompts for a starting point and branch name.  The worktree is
created at <repo-root>/.worktrees/<branch>."
    (interactive)
    (let* ((start-point (magit-read-branch-or-commit "Starting point"))
           (branch (read-string (format "New branch name (from %s): " start-point)))
           (directory (expand-file-name
                       branch
                       (expand-file-name ".worktrees" (magit-toplevel)))))
      (when (zerop (magit-run-git "worktree" "add" "-b" branch directory start-point))
        (tabspaces-open-or-create-project-and-workspace directory))))
  ;; Integrate with consult: show workspace-filtered buffers by default
  (with-eval-after-load 'consult
    (defvar consult--source-workspace
      (list :name "Workspace Buffers"
            :narrow ?w
            :history 'buffer-name-history
            :category 'buffer
            :state #'consult--buffer-state
            :default t
            :items (lambda () (consult--buffer-query
                               :predicate #'tabspaces--local-buffer-p
                               :sort 'visibility
                               :as #'buffer-name))))
    (add-to-list 'consult-buffer-sources 'consult--source-workspace)))

(provide 'setup-tabspaces)
;;; setup-tabspaces.el ends here
