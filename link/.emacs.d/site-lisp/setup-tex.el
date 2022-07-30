(quelpa '(auctex-latexmk
           :fetcher github
           :repo "smile13241324/auctex-latexmk"
           :commit "c1eedac3458a48da62d0bc59b86cf0529cc3920b"))

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
    (setq TeX-view-program-selection '((output-pdf "open")))
    (setq TeX-view-program-list
          '(("displayline" "displayline -r -b -g %n %o %b")
            ("open" "open %o"))
          )
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
  :ensure nil
  :init (auctex-latexmk-setup)
  (setq auctex-latexmk-inherit-TeX-PDF-mode t)
  :quelpa (auctex-latexmk
           :fetcher github
           :repo "smile13241324/auctex-latexmk"
           :commit "c1eedac3458a48da62d0bc59b86cf0529cc3920b")
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
