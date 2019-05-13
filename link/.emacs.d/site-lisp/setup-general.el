;; Share emacs
(require 'server)
(unless (server-running-p)
  (server-start))

;;; General modes
(delete-selection-mode t)
(recentf-mode 1)
(setq recentf-max-saved-items 2000)

;; Prevents the starting splash screen from opening. One less window to close
(setq inhibit-splash-screen t)

;; Emacs auto-save files
(setq
   backup-by-copying t     ; don't clobber
   backup-directory-alist
    '(("." . "~/.saves"))  ; don't litter my fs
   version-control t       ; use versioned backups
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2)

;; Use spaces, not tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(set-default 'truncate-lines t)

;;; bind RET to py-newline-and-indent
(add-hook 'python-mode-hook '(lambda ()
     (define-key python-mode-map "\C-m" 'newline-and-indent)))

;; Show column-number in the mode line
(column-number-mode 1)

;; human readable format for dired
(setq dired-listing-switches "-alh")

;; Turn off the top menu bar - no X windows for me :)
(menu-bar-mode 0)

;; I always accidentally run these, don't do them
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Highlight trailing whitespace
(setq-default show-trailing-whitespace t)

(put 'erase-buffer 'disabled nil)

;; Scroll until the first error in compilation window
(setq compilation-scroll-output 'first-error)

(require 're-builder)
(setq reb-re-syntax 'string)

;; ediff should split the screen horizontally to put the buffers side-by-side
(setq ediff-split-window-function 'split-window-horizontally)

;; make all prompts require the full yes/no (for when my
;; fingers/muscle memories are faster than my eyes/terminal)
(defalias 'y-or-n-p 'yes-or-no-p)

;;; Stefan Monnier - It is the opposite of fill-paragraph
(defun unfill-paragraph (&optional region)
  "Take a multi-line paragraph (REGION) and make it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(define-key global-map "\M-Q" 'unfill-paragraph)

;; C-x C-n to set a column goal
;; C-u C-x C-n to remove the goal
(put 'set-goal-column 'disabled nil)

(setq-default fill-column 80)

(setq-default indent-tabs-mode nil)

;; sources: http://steve.yegge.googlepages.com/my-dot-emacs-file
;;        : https://stackoverflow.com/questions/384284/how-do-i-rename-an-open-file-in-emacs
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(provide 'setup-general)
