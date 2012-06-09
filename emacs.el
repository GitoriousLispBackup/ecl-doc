(require 'cl)

(defvar ecl-search-string "")

(defun query-replace-ecl-doc  (from-string to-string &optional delimited start end)
  (interactive (query-replace-read-args "Query replace" nil))
  (let ((remaining (member (buffer-file-name (current-buffer)) ecl-doc-files)))
    (dolist (i (or remaining ecl-doc-files))
      (let ((b (find-buffer-visiting i)))
	(unless (equal b (current-buffer))
	  (switch-to-buffer b)
	  (beginning-of-buffer)))
      (perform-replace from-string to-string t nil delimited nil nil
		       start end))))

(defun query-replace-regexp-ecl-doc  (from-string to-string &optional delimited start end)
  (interactive (query-replace-read-args "Query replace" nil))
  (let ((remaining (member (buffer-file-name (current-buffer)) ecl-doc-files)))
    (dolist (i (or remaining ecl-doc-files))
      (let ((b (find-buffer-visiting i)))
	(unless (equal b (current-buffer))
	  (switch-to-buffer b)
	  (beginning-of-buffer)))
      (query-replace-regexp from-string to-string delimited start end))))

(defun search-ecl-doc  (string)
  (interactive "sString: ")
  (setq ecl-search-string string)
  (let ((remaining (member (buffer-file-name (current-buffer)) ecl-doc-files)))
    (dolist (i (or remaining ecl-doc-files))
      (let ((b (find-buffer-visiting i)))
	(unless (equal b (current-buffer))
	  (print b)
	  (switch-to-buffer b)
	  (beginning-of-buffer)))
      (print '*)
      (setq case-fold-search t)
      (if (search-forward string nil t)
	  (return)))))

(defun search-next-ecl-doc  ()
  (interactive)
  (search-ecl-doc  ecl-search-string))

(defun back-to-emacs ()
  (interactive)
  (switch-to-buffer "emacs.el"))

(defun next-ecl-doc  ()
  (interactive)
  (let ((remaining (member (buffer-file-name (current-buffer)) ecl-doc-files)))
    (when (cdr remaining)
      (switch-to-buffer (find-buffer-visiting (cadr remaining))))))

(global-set-key [?\M-p ?\C-i] 'back-to-emacs)
(global-set-key [?\M-p ?\C-s] 'search-ecl-doc )
(global-set-key [?\M-p ?\C-n] 'search-next-ecl-doc )
(global-set-key [?\M-p ?\C-m] 'next-ecl-doc )
(global-set-key [?\M-p ?\C-p] 'ecl-load-symbols)

(setq auto-mode-alist (acons "\\.d\\'" 'c-mode auto-mode-alist))

(setq ecl-doc-files
      (mapcar (lambda (x)
		(set-buffer "emacs.el")
		(concat (subseq (buffer-file-name (current-buffer)) 0 -8) x))
	      '(
"ecl.xml"
"asdf.xmlf"
"bibliography.xmlf"
"clos.xmlf"
"compiler.xmlf"
"copyright.xmlf"
"declarations.xmlf"
"discarded.xmlf"
"ecldev.xmlf"
"embed.xmlf"
"ffi.xmlf"
"gc.xmlf"
"internals.xmlf"
"interpreter.xmlf"
"intro.xmlf"
"io.xmlf"
"macros.xmlf"
"memory.xmlf"
"mop.xmlf"
"mp.xmlf"
"os.xmlf"
"pde.xmlf"
"preface.xmlf"
"ref_embed.xmlf"
"ref_memory.xmlf"
"ref_mp.xmlf"
"ref_os.xmlf"
"ref_signals.xmlf"
"signals.xmlf"
"standards.xmlf"
                )))

(mapcar 'find-file ecl-doc-files)

(defun ecl-doc-revert ()
  (interactive)
  (mapcar '(lambda (x) (let ((a (find-buffer-visiting x)))
			 (and a (switch-to-buffer a)
			      (revert-buffer t t))))
	  ecl-doc-files))

(defun ecl-doc-save ()
  (interactive)
  (mapcar '(lambda (x) (let ((a (find-buffer-visiting x)))
			 (and a (switch-to-buffer a)
			      (save-buffer 0))))
	  ecl-doc-files))