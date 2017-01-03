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
(defvar launch-proj "C:/rahuketu/programming/EMACS/LAUNCH" "Command line tool for launching project with custom settings")

(defun my-config()
  "Function to open org configuration file"
  (interactive)

  (find-file (expand-file-name config-file-name
                               user-emacs-directory)))

(defun my-launcher()
  (interactive)
  (dired launch-proj))

(setq inhibit-splash-screen t
      ;;      initial-scratch-message nil
      ;;    initial-major-mode 'org-mode
      )

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(unless (package-installed-p 'use-package)
 (package-refresh-contents)
 (package-install 'use-package))
;;  (setq use-package-verbose t)
;;  (setq use-package-always-ensure t)
 (eval-when-compile
 (require 'use-package))
 (use-package auto-compile
 :config (auto-compile-on-load-mode))
 (require 'diminish)
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

(use-package fsharp-mode
  :ensure t
  )

;;(use-package geiser
;;  :ensure t
;;  :config
;;  (setq geiser-racket-binary "Racket.exe")
;;  )

(use-package racket-mode
  :ensure t
  )

(use-package thrift
  :ensure t
  )

(use-package elm-mode
  :ensure t
  :defer t
  :config
   (add-to-list 'company-backends 'company-elm)
   (add-hook 'elm-mode-hook #'elm-oracle-setup-ac))

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

;; (load-file  "C:/rahuketu/programming/static-site/rahuketu86.github.io/src/elisp/blog.el")
(setq org-mode-websrc-directory  "C:/rahuketu/programming/static-site/rahuketu86.github.io/src" )
(setq org-mode-publishing-directory  "C:/rahuketu/programming/static-site/rahuketu86.github.io" )

(defvar website-html-preamble
  "<nav>
  <ul class='nav nav-tabs'>
     <li role='presentation'><a href='/'>Home</a></li>
     <li role='presentation'><a href='/content/pages/About.html'>About Me</a></li>
     <li role='presentation'><a href='/content/pages/IdeaFactory.html'>IdeaFactory</a></li>
  </ul>
  </nav>")

(defvar website-html-postamble 
  "
   <div class='text-center'>
      Copyright 2016-2020 %a.<br>
      Last updated %C. <br>
   </div>")

(setq org-publish-project-alist
    `(
        ("website" :components ("orgfiles"))
        ("orgfiles"
         :base-directory ,org-mode-websrc-directory
         :base-extension "org"
         :publishing-directory  ,org-mode-publishing-directory
         :exclude "*/excluded/*" 
         :recursive t
         :publishing-function org-twbs-publish-to-html
         :headline-levels 3
  	 :section-numbers nil
         :with-toc nil
  	 :html-preamble ,website-html-preamble
  	 :html-postamble ,website-html-postamble
        )
        )
    )


(defun blog-site-dir()
  (interactive)
  (dired org-mode-websrc-directory))

(use-package chess
  :ensure t
  :defer t)
