(setq package-enable-at-startup nil)
(tool-bar-mode -1)
;; Suppress "package cl is deprecated" warnings from third-party packages
;; that still use cl instead of cl-lib
(setq byte-compile-warnings '(not cl-functions obsolete))
