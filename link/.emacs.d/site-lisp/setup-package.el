(require 'package)
(setq package-archives
      '(
;;        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("elpa" . "http://tromey.com/elpa/")
;;        ("melpa-stable" . "http://stable.melpa.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ))
(package-initialize)

;; install the missing packages
(unless (package-installed-p 'use-package)
  ;; fetch the list of packages available
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install 'use-package)
  )

(eval-when-compile
  (require 'use-package)
  (require 'use-package-ensure)
  (setq use-package-always-ensure t)
 )

(provide 'setup-package)
