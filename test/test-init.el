;;* libs: 

;; test init
(add-to-list 'load-path (expand-file-name ".emacs.d/lisp/defuns/" "~"))
(add-to-list 'load-path (expand-file-name ".emacs.d/lisp/" "~"))
(add-to-list 'load-path (expand-file-name ".."))
(require 'nvp-local)
(require 'nvp-macros)

(setq user-package-dir (expand-file-name ".emacs.d/elpa/" "~"))
(prefer-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(package-initialize)

(eval-when-compile
  (require 'nvp-macros)
  (require 'smartparens))
(require 'nvp-local)
(require 'yasnippet)
(require 'company)
(require 'company-quickhelp)

(declare-function sp-local-pair "smartparens")

(load (expand-file-name "vbs-mode-autoloads.el" ".."))

;;* completion tests
(add-hook 'company-mode-hook #'company-quickhelp-mode)
(global-company-mode)
(setq company-quickhelp-max-lines 15)
(setq company-tooltip-align-annotations t)
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

(nvp-set yas-snippet-dirs nvp/snippet)
(yas-reload-all)

;;* bindings
(global-set-key (kbd "M-C-/") #'company-complete)
(global-set-key (kbd "M-/")   #'hippie-expand)
		
(defun nvp-vbs-hook ()
  (quietly-read-abbrev-file
   (nvp-setup-file "visual-basic-mode-abbrev-table" nvp/abbrevs))
  (yas-minor-mode))

(add-hook 'visual-basic-mode-hook #'nvp-vbs-hook)
