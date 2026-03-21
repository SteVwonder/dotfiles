(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  :demand t
  :bind
  ("C-c c" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup)
  :init
  (setq claude-code-ide-switch-tab-on-ediff nil)
  (setq claude-code-ide-prevent-reflow-glitch nil)
  :config
  (defun my/claude-code-update-window-width (&rest _)
    (setq claude-code-ide-window-width (floor (* 0.50 (frame-width)))))
  (my/claude-code-update-window-width)
  (add-hook 'window-size-change-functions #'my/claude-code-update-window-width))

(defun my/vterm-skip-claude-rename (orig-fn title)
  "Don't let vterm rename claude-code-ide buffers."
  (unless (string-prefix-p "*claude-code[" (buffer-name))
    (funcall orig-fn title)))

(advice-add 'vterm--set-title :around #'my/vterm-skip-claude-rename)

;;; Focus event forwarding for Claude Code vterm buffers
;;
;; vterm's libvterm has focus-in/focus-out support but doesn't expose it to
;; Emacs.  Claude Code uses terminal focus events (DECSET 1004) to hide its
;; cursor when the terminal isn't focused.  We bridge the gap by sending the
;; escape sequences directly when Emacs focus state changes.

(defun my/claude-vterm-p (buf)
  "Return non-nil if BUF is a live Claude Code vterm buffer."
  (and (buffer-live-p buf)
       (string-prefix-p "*claude-code[" (buffer-name buf))
       (buffer-local-value 'vterm--process buf)
       (process-live-p (buffer-local-value 'vterm--process buf))))

(defun my/claude-send-focus (buf focus-in)
  "Send focus-in or focus-out escape sequence to Claude Code vterm BUF."
  (let ((proc (buffer-local-value 'vterm--process buf)))
    (when (and proc (process-live-p proc))
      (process-send-string proc (if focus-in "\e[I" "\e[O")))))

(defvar my/claude-focused-buffer nil
  "The Claude Code vterm buffer that currently has terminal focus.")

(defvar my/claude-focus-initialized (make-hash-table :test 'eq :weakness 'key)
  "Tracks Claude Code buffers that have received their first focus-out.
Focus-in is only sent after the first focus-out, to avoid sending
a premature focus-in before the TUI has loaded.")

(defun my/claude-update-focus (&rest _)
  "Update terminal focus state for Claude Code vterm buffers.
Sends focus-in/focus-out escape sequences so Claude Code can
show/hide its cursor appropriately."
  (let* ((focused-frame (seq-some (lambda (f) (and (frame-focus-state f) f))
                                  (frame-list)))
         (selected-buf (when focused-frame
                         (window-buffer (frame-selected-window focused-frame))))
         (target (when (and selected-buf (my/claude-vterm-p selected-buf))
                   selected-buf)))
    (unless (eq target my/claude-focused-buffer)
      ;; Focus out the previously focused buffer
      (when (and my/claude-focused-buffer
                 (my/claude-vterm-p my/claude-focused-buffer))
        (my/claude-send-focus my/claude-focused-buffer nil)
        (puthash my/claude-focused-buffer t my/claude-focus-initialized))
      ;; Focus in the newly focused buffer (only after first focus-out)
      (when (and target (gethash target my/claude-focus-initialized))
        (my/claude-send-focus target t))
      (setq my/claude-focused-buffer target))))

;; Frame-level focus changes (e.g. switching to another application)
(add-function :after after-focus-change-function #'my/claude-update-focus)
;; Window-level focus changes (e.g. switching between Emacs windows)
(add-hook 'window-selection-change-functions #'my/claude-update-focus)

(provide 'setup-ai)
