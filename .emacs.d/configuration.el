(setq custom-file
      (expand-file-name "custom.el"
                        user-emacs-directory))

'(require 'package)
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

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

(use-package guru-mode
  :ensure t
  :config
  (guru-global-mode +1))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))
