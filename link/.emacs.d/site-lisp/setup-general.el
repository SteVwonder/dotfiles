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

(provide 'setup-general)
