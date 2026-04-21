;;; setup-cc-notify.el --- Surface blocked Claude Code instances in tab-bar -*- lexical-binding: t; -*-

;; Tracks which tabspaces host a Claude Code instance that is waiting on
;; user input. External shell hooks (see dotfiles/conf/claude/hooks/
;; cc-emacs-notify/) call `my/cc-mark-blocked' and `my/cc-mark-unblocked'
;; via emacsclient. Blocked tabs get a prefix glyph; `my/cc-switch-to-blocked'
;; jumps to one.

(require 'cl-lib)
(require 'tab-bar)
(require 'project)

(defgroup my/cc-notify nil
  "Surface blocked Claude Code instances in the tab-bar."
  :group 'convenience)

(defvar my/cc-blocked-projects nil
  "Alist mapping canonical project root -> plist of blocked-state info.
Plist keys: :state (symbol `idle' or `permission'), :session-id (string),
:since (Lisp time value).")

(defface my/cc-blocked-idle-face
  '((t :inherit warning :weight bold))
  "Face for the tab-bar glyph when CC is idle-waiting."
  :group 'my/cc-notify)

(defface my/cc-blocked-permission-face
  '((t :inherit error :weight bold))
  "Face for the tab-bar glyph when CC is awaiting a permission decision."
  :group 'my/cc-notify)

(defcustom my/cc-blocked-idle-glyph "● "
  "Glyph prefixed to a tab name when CC is idle-waiting."
  :type 'string
  :group 'my/cc-notify)

(defcustom my/cc-blocked-permission-glyph "⛔ "
  "Glyph prefixed to a tab name when CC is awaiting a permission decision."
  :type 'string
  :group 'my/cc-notify)

(defun my/cc--normalize-root (path)
  "Return the canonical project root for PATH, or PATH as a directory."
  (let ((dir (file-name-as-directory (expand-file-name path))))
    (or (ignore-errors
          (let ((default-directory dir))
            (when-let ((proj (project-current nil dir)))
              (file-name-as-directory (expand-file-name (project-root proj))))))
        dir)))

(defun my/cc--tab-has-buffer-under-root-p (tab root)
  "Return non-nil when TAB has any buffer whose default-directory is under ROOT."
  (let* ((root (file-name-as-directory (expand-file-name root)))
         ;; tabspaces stores buffer lists on tabs; keys vary by version.
         (bufs (or (cdr (assq 'ws-buffer-list tab))
                   (cdr (assq 'wc-bl tab))
                   (cdr (assq 'wc-bbl tab)))))
    (cl-some
     (lambda (b)
       (let ((buf (cond ((bufferp b) b)
                        ((stringp b) (get-buffer b)))))
         (and buf
              (buffer-live-p buf)
              (with-current-buffer buf
                (and default-directory
                     (string-prefix-p
                      root
                      (file-name-as-directory
                       (expand-file-name default-directory))))))))
     bufs)))

(defun my/cc--tab-name-matches-root-p (tab root)
  "Fallback: match tabspace TAB name against the basename of ROOT."
  (let ((basename (file-name-nondirectory
                   (directory-file-name (expand-file-name root)))))
    (equal basename (alist-get 'name tab))))

(defun my/cc--tab-blocked-state (tab)
  "Return the blocked state symbol for TAB, or nil if not blocked."
  (cl-loop for (root . info) in my/cc-blocked-projects
           when (or (my/cc--tab-has-buffer-under-root-p tab root)
                    (my/cc--tab-name-matches-root-p tab root))
           return (plist-get info :state)))

(defun my/cc--find-tab-index-for-root (root)
  "Return 1-based tab index whose project matches ROOT, or nil."
  (let* ((tabs (funcall tab-bar-tabs-function))
         (idx (cl-position-if
               (lambda (tab)
                 (or (my/cc--tab-has-buffer-under-root-p tab root)
                     (my/cc--tab-name-matches-root-p tab root)))
               tabs)))
    (and idx (1+ idx))))

(defun my/cc--refresh ()
  "Force tab-bar and mode-line redisplay."
  (force-mode-line-update t)
  (when (fboundp 'tab-bar--update-tab-bar-lines)
    (ignore-errors (tab-bar--update-tab-bar-lines))))

;;;###autoload
(defun my/cc-mark-blocked (cwd state session-id)
  "Record that a CC instance rooted at CWD is blocked with STATE.
STATE is \"idle\" or \"permission\". `permission' outranks `idle' and
won't be downgraded by a subsequent `idle' mark."
  (let* ((root (my/cc--normalize-root cwd))
         (new-state (intern state))
         (existing (cdr (assoc root my/cc-blocked-projects)))
         (existing-state (and existing (plist-get existing :state))))
    (unless (and (eq existing-state 'permission) (eq new-state 'idle))
      (setf (alist-get root my/cc-blocked-projects nil nil #'equal)
            (list :state new-state
                  :session-id session-id
                  :since (current-time))))
    (my/cc--refresh)))

;;;###autoload
(defun my/cc-mark-unblocked (cwd &optional _state _session-id)
  "Clear blocked state for the project rooted at CWD."
  (let ((root (my/cc--normalize-root cwd)))
    (setq my/cc-blocked-projects
          (assoc-delete-all root my/cc-blocked-projects))
    (my/cc--refresh)))

(defun my/cc--format-tab-name (tab i)
  "Wrap the default tab-bar formatter, prefixing blocked tabs with a glyph."
  (let ((default (tab-bar-tab-name-format-default tab i))
        (state (my/cc--tab-blocked-state tab)))
    (pcase state
      ('permission (concat (propertize my/cc-blocked-permission-glyph
                                       'face 'my/cc-blocked-permission-face)
                           default))
      ('idle (concat (propertize my/cc-blocked-idle-glyph
                                 'face 'my/cc-blocked-idle-face)
                     default))
      (_ default))))

(setq tab-bar-tab-name-format-function #'my/cc--format-tab-name)

(defun my/cc--clear-on-tab-switch (&rest _)
  "When a tab becomes current, clear any blocked entry for its project."
  (when-let* ((proj (project-current))
              (root (file-name-as-directory
                     (expand-file-name (project-root proj)))))
    (when (assoc root my/cc-blocked-projects)
      (setq my/cc-blocked-projects
            (assoc-delete-all root my/cc-blocked-projects))
      (my/cc--refresh))))

(if (boundp 'tab-bar-tab-post-select-functions)
    (add-hook 'tab-bar-tab-post-select-functions #'my/cc--clear-on-tab-switch)
  (advice-add 'tab-bar-select-tab :after #'my/cc--clear-on-tab-switch))

(defun my/cc--format-age (since)
  "Format elapsed time SINCE as a short string."
  (let ((secs (floor (float-time (time-subtract (current-time) since)))))
    (cond
     ((< secs 60) (format "%ds" secs))
     ((< secs 3600) (format "%dm" (/ secs 60)))
     (t (format "%dh%dm" (/ secs 3600) (/ (mod secs 3600) 60))))))

;;;###autoload
(defun my/cc-switch-to-blocked ()
  "Switch to a tabspace hosting a blocked Claude Code instance.
Jumps directly if only one is blocked, otherwise prompts with state
and age."
  (interactive)
  (cond
   ((null my/cc-blocked-projects)
    (message "No blocked Claude Code instances"))
   ((= 1 (length my/cc-blocked-projects))
    (my/cc--switch-to-root (caar my/cc-blocked-projects)))
   (t
    (let* ((items
            (mapcar
             (lambda (cell)
               (let* ((root (car cell))
                      (info (cdr cell))
                      (state (plist-get info :state))
                      (since (plist-get info :since))
                      (glyph (pcase state
                               ('permission my/cc-blocked-permission-glyph)
                               (_ my/cc-blocked-idle-glyph)))
                      (label (format "%s%-12s  %s  (%s)"
                                     glyph
                                     (symbol-name state)
                                     root
                                     (my/cc--format-age since))))
                 (cons label root)))
             my/cc-blocked-projects))
           (choice (completing-read "Blocked Claude Code: " items nil t)))
      (my/cc--switch-to-root (cdr (assoc choice items)))))))

(defun my/cc--switch-to-root (root)
  "Switch to the tabspace matching ROOT, creating one if needed."
  (let ((idx (my/cc--find-tab-index-for-root root)))
    (cond
     (idx (tab-bar-select-tab idx))
     ((fboundp 'tabspaces-open-or-create-project-and-workspace)
      (tabspaces-open-or-create-project-and-workspace root))
     (t (message "No tabspace found for %s" root)))))

(with-eval-after-load 'tabspaces
  (when (boundp 'tabspaces-mode-map)
    (define-key tabspaces-mode-map (kbd "M-t b") #'my/cc-switch-to-blocked)))

(provide 'setup-cc-notify)
;;; setup-cc-notify.el ends here
