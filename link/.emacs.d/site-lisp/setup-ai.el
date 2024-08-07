(use-package shell-maker
  :straight (:host github :repo "xenodium/chatgpt-shell" :files ("shell-maker.el")))

(use-package chatgpt-shell
  :requires shell-maker
  :straight (:host github :repo "xenodium/chatgpt-shell" :files ("chatgpt-shell.el")))

;; or if using auth-sources, e.g., so the file ~/.authinfo has this line:
;;  machine api.openai.com password OPENAI_KEY
;; (setq chatgpt-shell-openai-key
;;      (auth-source-pick-first-password :host "api.openai.com"))
;; or same as previous but lazy loaded (prevents unexpected passphrase prompt)
(setq chatgpt-shell-openai-key
      (lambda ()
        (auth-source-pick-first-password :host "api.openai.com")))

(provide 'setup-ai)
