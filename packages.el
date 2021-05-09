;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.

;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
(package! tree-sitter)
(package! tree-sitter-langs)

(package! org-page :recipe
  (:local-repo "~/Documents/emacs-pkg-dev/org-page"
   :build (:not compile)))

(package! evil-lispy :recipe
  (:local-repo "~/Documents/emacs-pkg-dev/evil-lispy"
   :build (:not compile)))

(package! tree-edit :recipe
  (:local-repo "~/Documents/emacs-pkg-dev/tree-edit"
   :build (:not compile)))
