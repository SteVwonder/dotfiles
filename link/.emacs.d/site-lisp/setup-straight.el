(setq straight-check-for-modifications '(check-on-save))
(setq straight-use-package-by-default t)
(setq straight-host-usernames '((github . "stevwonder")))

(setf straight-build-dir "~/.emacs.d/straight"
      straight-profiles `((nil . ,"~/.emacs.d/straight.lockfile.el")))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Use the built-in use-package (Emacs 29+) and integrate it with straight
(straight-use-package '(use-package :type built-in))


(provide 'setup-straight)
