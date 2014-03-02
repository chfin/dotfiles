;;; general settings

(setq-default indent-tabs-mode nil)

;;; packages

(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

;;; autocomplete
(require 'auto-complete)
(global-auto-complete-mode t)
(auto-complete-mode t)

;;; lisp

(load (expand-file-name "~/lisp/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")

(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))

(autoload 'my-enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)

(defvar electrify-return-match
  "[\]}\)\"]"
  "If this regexp matches the text after the cursor, do an \"electric\" return.")

(defun electrify-return-if-match (arg)
  "If the text after the cursor matches `electrify-return-match' then
  open and indent an empty line between the cursor and the text.  Move the
  cursor to the new line."
  (interactive "P")
  (let ((case-fold-search nil))
    (if (looking-at electrify-return-match)
	(save-excursion (newline-and-indent)))
    (newline arg)
    (indent-according-to-mode)))

(defun my-enable-paredit-mode ()
  (paredit-mode t)
  ;(local-set-key (kbd "<M-right>") 'paredit-forward-slurp-sexp)
  ;(local-set-key (kbd "<M-left>") 'paredit-forward-barf-sexp)
  ;(local-set-key (kbd "<C-right>") 'right-word)
  ;(local-set-key (kbd "<C-left>") 'left-word)
  ;(local-set-key (kbd "RET") 'electrify-return-if-match)
  (setq paredit-commands
	(remove-duplicates
	 (append 
	  '((("C-)" "M-<right>")
	     paredit-forward-slurp-sexp
	     ("(foo (bar |baz) quux zot)"
	      "(foo (bar |baz quux) zot)")
	     ("(a b ((c| d)) e f)"
	      "(a b ((c| d) e) f)"))
	    (("C-}" "M-<left>")
	     paredit-forward-barf-sexp
	     ("(foo (bar |baz quux) zot)"
	      "(foo (bar |baz) quux zot)"))
	    (("C-<right>")
	     right-word)
	    (("C-<left>")
	     left-word)
	    (("RET")
	     electrify-return-if-match ())))
	 :test 'equal))
  (paredit-define-keys)
  (paredit-annotate-mode-with-examples)
  (paredit-annotate-functions-with-examples)
  (show-paren-mode t))

(add-hook 'emacs-lisp-mode-hook       #'my-enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'my-enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'my-enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'my-enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'my-enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'my-enable-paredit-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 97 :width normal)))))
