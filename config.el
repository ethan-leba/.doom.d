;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;;* Custom functions for lispy
(defun inner-bounds (bound)
  (cons (+ 1 (car bound)) (- (cdr bound) 1)))

(defun leba-lispy-bounds ()
  (interactive)
  (if (not mark-active)
      (inner-bounds (bounds-of-thing-at-point 'sexp))
    ;; TODO: handle string case
    (let ( (result (car (region-bounds))))
      (progn
	(setq mark-active nil)
	result))))

(defun leba-lispy-insert ()
  (interactive)
  (goto-char (car (leba-lispy-bounds)))
  (evil-insert-state))

(defun leba-lispy-append ()
  (interactive)
  (goto-char (cdr (leba-lispy-bounds)))
  (evil-insert-state))
;;* Misc settings
(setq user-full-name "Ethan Leba"
      user-mail-address "ethanleba5@gmail.com")

(setq doom-evil-state-alist `((?l . lispy) . ,doom-evil-state-alist))


;; Doesn't matter what it is, we're simulating it!
(setq doom-leader-alt-key "M-o")

(setq doom-theme 'doom-one)
(setq +format-on-save-enabled-modes '(python-mode))

(setq org-directory "~/Dropbox/org/")

(setq display-line-numbers-type nil)
(delete-selection-mode 1)

(after! flycheck (flycheck-add-next-checker 'python-mypy 'python-flake8))

;; Set proper mac modifier
(setq mac-command-modifier 'meta)

(after! evil-snipe
  (evil-snipe-mode -1))

;;* Easymotion operators
(evil-define-operator evil-substitute (beg end type register)
  "Change a character."
  (interactive "<R><x>")
  (evil-delete beg end type ?_)
  (evil-paste-before register))

(evil-define-operator evil-discard (beg end type register)
  "Delete without adding to register"
  (interactive "<R>")
  (evil-delete beg end type ?_))

(evil-define-operator lispyville-substitute (beg end type register)
  "Change a character."
  (interactive "<R><x>")
  (lispyville-delete beg end type ?_)
  (evil-paste-before register))

(evil-define-operator lispyville-discard (beg end type register)
  "Delete without adding to register"
  (interactive "<R>")
  (lispyville-delete beg end type ?_))

;;* Keybindings
(map! :nv ":" #'counsel-M-x
      :n "d" #'evil-discard
      :n "m" #'evil-delete
      :n "s" #'evil-substitute
      ;; Shell stuff
      (:prefix "SPC a"
       :nv "a" #'projectile-run-async-shell-command-in-root
       :nv "s" #'projectile-run-eshell
       ;; :nv "r" #'shell
       )
      ;; XXX: not a keymap??
      ;; (:map eshell-mode-map
      ;;  :localleader
      ;;  "/" #'eshell-isearch-backward)
      :i "C-l" #'forward-char)

(map! (:map eshell-mode-map
       :localleader
       "k" #'eshell-kill-process))
(map!
 :map lispyville-mode-map
 :n "d" 'lispyville-discard
 :n "m" 'lispyville-delete)

(map! :map general-override-mode-map
      :l "SPC" 'doom/leader)

(add-hook 'post-command-hook
          (lambda () (when (and (not (or (region-active-p)
                                    (lispy-left-p)
                                    (lispy-right-p)
                                    (and (lispy-bolp)
                                         (or (looking-at lispy-outline-header)
                                             (looking-at lispy-outline)))))
                           (evil-lispy-state-p))
                  (evil-insert-state))))
(map!
 :map evil-lispy-mode-map
 :l "i" 'leba-lispy-insert
 :l "I" 'leba-lispy-append
 :l "TAB" 'lispy-tab
 ;; :l "}" '(lambda (arg) (interactive "P") (lispy-brackets arg) (evil-insert-state))
 ;; :l "{" '(lambda (arg) (interactive "P") (lispy-braces arg) (evil-insert-state))
 ;; :l "(" '(lambda (arg) (interactive "P") (lispy-parens arg) (evil-insert-state))
 )

(global-prettify-symbols-mode 1)
(setq evil-disable-insert-state-bindings t)
(after! evil
  (defalias 'forward-evil-word 'forward-evil-symbol))

(after! tree-sitter
  (setq tree-sitter-debug-jump-buttons t))

(require 'evil-lispy)
(add-hook 'emacs-lisp-mode-hook
          #'evil-lispy-mode)

;;* Org page settings
(require 'org-page)

(setq op/theme-root-directory "~/Documents/ethan-leba-website/themes/"
      op/repository-directory "~/Documents/ethan-leba-website"
      op/site-domain "www.ethanleba.com"
      op/personal-github-link "https://github.com/ethan-leba"
      op/site-main-title "Ethan Leba"
      op/site-sub-title ""
      op/category-ignore-list '("blog" "themes"))
