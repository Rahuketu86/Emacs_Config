(setq custom-file
      (expand-file-name "custom.el"
                        user-emacs-directory))

(require 'package)
;;;(add-to-list 'package-archives
;;;'             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/")
             t)

    (add-to-list 'package-archives 
	         '("org" . "http://orgmode.org/elpa/")
			     t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(setq user-full-name "Rahul Saraf"
     user-mail-address "rahuketu86@gmail.com")

(setq Info-default-directory-list
      (append
              Info-default-directory-list
              '("~/info" )))
(add-hook 'Info-mode-hook           ; After Info-mode has started
    (lambda ()
        (setq Info-additional-directory-list Info-default-directory-list)
    ))

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)

(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
    '(kill-ring
      search-ring
      regexp-search-ring))

(add-to-list 'Info-default-directory-list "~/.emacs.d/info")

(defvar config-file-name "configuration.org")

(defun my-config()
  "Function to open org configuration file"
  (interactive)

  (find-file (expand-file-name config-file-name
                               user-emacs-directory)))

(setq inhibit-splash-screen t
      ;;      initial-scratch-message nil
      ;;    initial-major-mode 'org-mode
      )

(scroll-bar-mode -1)
(tool-bar-mode -1)
;; (menu-bar-mode -1)

(unless (package-installed-p 'use-package)
 (package-refresh-contents)
 (package-install 'use-package))
;;  (setq use-package-verbose t)
;;  (setq use-package-always-ensure t)
 ;; (eval-when-compile
 ;; (require 'use-package))
 ;; (use-package auto-compile
 ;; :config (auto-compile-on-load-mode))
 ;; (require 'diminish)
;;  ;;
(require 'bind-key)

(setq w32-get-true-file-attributes nil)

(use-package monokai-theme
  :ensure t
  :init (load-theme 'monokai t))

;; Activate ido
(require 'ido)
(ido-mode t)

;; Set up smex
(use-package smex
  :ensure t
  :bind (("M-x" . smex))
  :config (smex-initialize))

(use-package guru-mode
  :ensure t
  :init
  (setq-default major-mode 'text-mode)
  :config
  (add-hook 'prog-mode-hook 'guru-mode)
  (add-hook 'text-mode-hook 'guru-mode)
 )

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package company
      :ensure t
      :defer t
      :config
       (global-company-mode)

;;      :config
;;       (global-company-mode))
	   )

(use-package org-mode
  :init (remove-hook 'org-mode-hook 'guru-mode)
  :bind (("\C-cl" . org-store-link)
         ("\C-ca" . org-agenda)
         ("\C-cc" . org-capture)
         ("\C-cb" . org-iswitch))
  :config
   (remove-hook 'org-mode-hook 'guru-mode))

(use-package ox-twbs
  :ensure t
  :defer t)

(use-package htmlize
 :ensure t)
(require 'org)
(require 'ox-html)

;;; Custom configuration for the export.

;;; Add any custom configuration that you would like to 'conf.el'.
(setq nikola-use-pygments t
      org-export-with-toc nil
      org-export-with-section-numbers nil
      org-startup-folded 'showeverything)

;; Load additional configuration from conf.el
(let ((conf (expand-file-name "conf.el" (file-name-directory load-file-name))))
  (if (file-exists-p conf)
      (load-file conf)))

;;; Macros

;; Load Nikola macros
(setq nikola-macro-templates
      (with-current-buffer
	  (find-file
	   (expand-file-name "macros.org" (file-name-directory load-file-name)))
	(org-macro--collect-macros)))

;;; Code highlighting
(defun org-html-decode-plain-text (text)
  "Convert HTML character to plain TEXT. i.e. do the inversion of
     `org-html-encode-plain-text`. Possible conversions are set in
     `org-html-protect-char-alist'."
  (mapc
   (lambda (pair)
     (setq text (replace-regexp-in-string (cdr pair) (car pair) text t t)))
   (reverse org-html-protect-char-alist))
  text)

;; Use pygments highlighting for code
(defun pygmentize (lang code)
  "Use Pygments to highlight the given code and return the output"
  (with-temp-buffer
    (insert code)
    (let ((lang (or (cdr (assoc lang org-pygments-language-alist)) "text")))
      (shell-command-on-region (point-min) (point-max)
			       (format "pygmentize -f html -l %s" lang)
			       (buffer-name) t))
    (buffer-string)))

(defconst org-pygments-language-alist
  '(("asymptote" . "asymptote")
    ("awk" . "awk")
    ("c" . "c")
    ("c++" . "cpp")
    ("cpp" . "cpp")
    ("clojure" . "clojure")
    ("css" . "css")
    ("d" . "d")
    ("emacs-lisp" . "scheme")
    ("F90" . "fortran")
    ("gnuplot" . "gnuplot")
    ("groovy" . "groovy")
    ("haskell" . "haskell")
    ("java" . "java")
    ("js" . "js")
    ("julia" . "julia")
    ("latex" . "latex")
    ("lisp" . "lisp")
    ("makefile" . "makefile")
    ("matlab" . "matlab")
    ("mscgen" . "mscgen")
    ("ocaml" . "ocaml")
    ("octave" . "octave")
    ("perl" . "perl")
    ("picolisp" . "scheme")
    ("python" . "python")
    ("r" . "r")
    ("ruby" . "ruby")
    ("sass" . "sass")
    ("scala" . "scala")
    ("scheme" . "scheme")
    ("sh" . "sh")
    ("sql" . "sql")
    ("sqlite" . "sqlite3")
    ("tcl" . "tcl"))
  "Alist between org-babel languages and Pygments lexers.
lang is downcased before assoc, so use lowercase to describe language available.
See: http://orgmode.org/worg/org-contrib/babel/languages.html and
http://pygments.org/docs/lexers/ for adding new languages to the mapping.")

;; Override the html export function to use pygments
;; (defun org-html-src-block (src-block contents info)
;;   "Transcode a SRC-BLOCK element from Org to HTML.
;; CONTENTS holds the contents of the item.  INFO is a plist holding
;; contextual information."
;;   (if (org-export-read-attribute :attr_html src-block :textarea)
;;       (org-html--textarea-block src-block)
;;     (let ((lang (org-element-property :language src-block))
;; 	  (code (org-element-property :value src-block))
;; 	  (code-html (org-html-format-code src-block info)))
;;       (if nikola-use-pygments
;; 	  (pygmentize (downcase lang) (org-html-decode-plain-text code))
;; 	code-html))))

;; ;; Export images with custom link type
(defun org-custom-link-img-url-export (path desc format)
  (cond
   ((eq format 'html)
    (format "<img src=\"%s\" alt=\"%s\"/>" path desc))))
(org-add-link-type "img-url" nil 'org-custom-link-img-url-export)

;; Export function used by Nikola.
(defun nikola-html-export (infile outfile)
  "Export the body only of the input file and write it to
specified location."
  (with-current-buffer (find-file infile)
    (org-macro-replace-all nikola-macro-templates)
    (org-html-export-as-html nil nil t t)
    (write-file outfile nil)))

(use-package chess
  :ensure t
  :defer t)
