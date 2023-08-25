(setq straight-check-for-modifications '(check-on-save))
(setq straight-use-package-by-default t)
(setq package-enable-at-startup nil)
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

(straight-use-package 'use-package)

(provide 'setup-straight)
