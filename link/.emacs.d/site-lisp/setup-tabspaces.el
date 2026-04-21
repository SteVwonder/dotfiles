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
  (setq tabspaces-keymap-prefix "M-t")
  :config
  (defun my/project-open-buffers ()
    "Open magit status and a vterm in the current project."
    (interactive)
    ;; Remove the carried-over buffer from this workspace so it
    ;; doesn't get killed when the workspace is closed
    (let ((old-buf (current-buffer)))        ; save the carried-over buffer
      (set-window-parameter (selected-window) 'quit-restore nil) ; prevent quit-window from restoring it
      (magit-project-status)                 ; open magit in the current window
      (delete-other-windows)                 ; ensure a clean single-window layout
      (split-window-right)                   ; create a right pane
      (other-window 1)                       ; move to the right pane
      (vterm t)                              ; open vterm there
      (other-window -1)                      ; move focus back to magit
      (set-frame-parameter nil 'buffer-list  ; remove carried-over buffer from this
                           (delq old-buf (frame-parameter nil 'buffer-list))))) ; workspace so it won't be killed with it
  (setq tabspaces-project-switch-commands #'my/project-open-buffers)

  (defun my/git-main-worktree-root ()
    "Return the main worktree's top directory, even from a linked worktree.
Uses `--git-common-dir' (the shared `.git' dir for all worktrees); its
parent is the main worktree root."
    (when-let ((common-dir (magit-git-string
                            "rev-parse" "--path-format=absolute"
                            "--git-common-dir")))
      (file-name-as-directory
       (file-name-directory (directory-file-name common-dir)))))

  (defun my/worktree-open-in-tabspace ()
    "Create a new branch in a worktree and open it as a tabspace.
Prompts for a starting point and branch name.  The worktree is
created at <main-repo-root>/.worktrees/<branch>, even when invoked
from within an existing worktree."
    (interactive)
    (let* ((start-point (magit-read-branch-or-commit "Starting point"))
           (branch (read-string (format "New branch name (from %s): " start-point)))
           (directory (expand-file-name
                       branch
                       (expand-file-name ".worktrees"
                                         (my/git-main-worktree-root)))))
      (when (zerop (magit-run-git "worktree" "add" "-b" branch directory start-point))
        (tabspaces-open-or-create-project-and-workspace directory))))

  (defun my/worktree-close-tabspace-and-remove ()
    "Close the current tabspace and remove its associated worktree.
Only works when the current tabspace's root lives under a
`.worktrees/' directory."
    (interactive)
    (let ((worktree (magit-toplevel)))
      (unless (and worktree
                   (string-match-p "/\\.worktrees/[^/]+/?\\'" worktree))
        (user-error "Not inside a .worktrees tabspace"))
      (when (yes-or-no-p (format "Close tabspace and remove worktree %s? " worktree))
        (let ((default-directory (my/git-main-worktree-root)))
          (tabspaces-kill-buffers-close-workspace)
          (magit-run-git "worktree" "remove" worktree)))))
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
