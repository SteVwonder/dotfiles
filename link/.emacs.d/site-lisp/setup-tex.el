(use-package tex
  :ensure auctex
  :init
  (setq TeX-PDF-mode t)
    )

(use-package auctex-latexmk
  :ensure t
  :init (auctex-latexmk-setup)
  (setq auctex-latexmk-inherit-TeX-PDF-mode t)
  )

(use-package company-auctex
  :ensure t
  )

(provide 'setup-tex)
