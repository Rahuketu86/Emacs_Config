(setq custom-file
      (expand-file-name "custom.el"
                        user-emacs-directory))

(require 'package)
;;;(add-to-list 'package-archives
;;;'             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(defun my-config()
  "Function to open org configuration file"
  (interactive)
;;  (find-file load-file-name))
  (find-file (expand-file-name "configuration.org"
                               user-emacs-directory)))

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

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

(setq w32-get-true-file-attributes nil)

(use-package monokai-theme
  :ensure t
  :init(load-theme 'monokai t))

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

(use-package geiser
  :ensure t
  :config
  (setq geiser-racket-binary "c:/Program Files (x86)/Racket/Racket.exe")
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

(use-package chess
  :ensure t
  :defer t)
