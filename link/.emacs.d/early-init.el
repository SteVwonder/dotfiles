(setq package-enable-at-startup nil)

(setq default-frame-alist
      (append
       '((tool-bar-lines . 0)        ; disable tool bar on GUI frames
         (menu-bar-lines . 0)        ; often also disabled
         (vertical-scroll-bars . nil))
       default-frame-alist))

;; Suppress "package cl is deprecated" warnings from third-party packages
;; that still use cl instead of cl-lib
(setq byte-compile-warnings '(not cl-functions obsolete))
