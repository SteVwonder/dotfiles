(setq package-enable-at-startup nil)
;; Suppress "package cl is deprecated" warnings from third-party packages
;; that still use cl instead of cl-lib
(setq byte-compile-warnings '(not cl-functions obsolete))
