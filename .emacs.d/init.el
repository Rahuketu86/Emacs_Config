;; init.el for this setup. Must use Emacs24
(require 'org)
(org-babel-load-file 
	(expand-file-name "configuration.org"
						user-emacs-directory))