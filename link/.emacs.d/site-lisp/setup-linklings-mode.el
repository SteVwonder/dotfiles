(require 'generic-x)

(define-generic-mode 'linklings-generic-mode
  '("//")      ;; comments start with //
  '("<<" ">>") ;; keywords
  '(("-" . 'font-lock-doc-face)
    ("<<NEW REVIEW>>" . 'font-lock-builtin-face)
    ("<<REVIEW QUESTIONS>>" . 'font-lock-builtin-face)
    ("<<\\.\\*>>" . 'font-lock-doc-face))      ;; font locks
  '("\\-reviews.txt$") ;; file name
  (flyspell-mode)
  "A mode for linklings reviews")


(define-derived-mode linklings-mode text-mode "Linklings Reviews"
  "Linklings mode is a major mode for editing Linklings-style reviews.
It is derived from text-mode and includes some 'syntax' highlightling."
  (setq font-lock-defaults `((("<< .* >>" . font-lock-keyword-face)
                              ("<<NEW REVIEW>>" . font-lock-builtin-face)
                              ("<<REVIEW QUESTIONS>>" . font-lock-builtin-face)
                              ("--+" . font-lock-doc-face)
                              ("//.*" . font-lock-comment-face))))
  (setq comment-start "//")
  (setq comment-end ""))

(provide 'setup-linklings-mode)
