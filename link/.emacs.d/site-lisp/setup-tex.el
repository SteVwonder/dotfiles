(use-package tex
  :ensure auctex
  :init
  (setq TeX-PDF-mode t)
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)

  ;; ##### Always ask for the master file
  ;; ##### when creating a new TeX file.
  (setq-default TeX-master nil)

  ;; ##### Enable synctex correlation. From Okular just press
  ;; ##### Shift + Left click to go to the good line.
  (setq TeX-source-correlate-mode t
        TeX-source-correlate-start-server t)

  (when (eq system-type 'darwin)
    (dolist (dir '("/Applications/Skim.app/Contents/SharedSupport"))
      (add-to-list 'exec-path dir))
    (setq TeX-source-correlate-method 'synctex)
    (setq TeX-view-program-selection '((output-pdf "displayline")))
    (setq TeX-view-program-list
          '(("displayline" "displayline -r -b -g %n %o %b")))
    ;; (add-hook 'LaTeX-mode-hook
    ;;           (lambda () (local-set-key (kbd "<S-s-mouse-1>") #'TeX-view))
    ;;           )
    )
  (when (eq system-type 'gnu/linux)
      ;; ### Set Okular as the default PDF viewer.
      (eval-after-load "tex"
        '(setcar (cdr (assoc 'output-pdf TeX-view-program-selection)) "Okular")
        )
    )
  )

(use-package auctex-latexmk
  :ensure t
  :init (auctex-latexmk-setup)
  (setq auctex-latexmk-inherit-TeX-PDF-mode t)
  )

(use-package company-auctex
  :ensure t
  )

;; ##### Don't forget to configure
;; ##### Okular to use emacs in
;; ##### "Configuration/Configure Okular/Editor"
;; ##### => Editor => Emacsclient. (you should see
;; ##### emacsclient -a emacs --no-wait +%l %f
;; ##### in the field "Command".

(provide 'setup-tex)
