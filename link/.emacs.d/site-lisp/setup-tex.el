(use-package tex
  :ensure auctex
  :init
  (setq TeX-PDF-mode t)
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
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
