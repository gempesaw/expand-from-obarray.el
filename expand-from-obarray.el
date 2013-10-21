(require 's)
(require 'ht)

(defvar efo-abbrev-cache nil
  "The cache of abbrev => defun relationships")

(defun efo-expand-abbrev-at-point ()
  (interactive)
  (let ((defun-abbrevs)
        (abbrev (thing-at-point 'word))
        (bounds (bounds-of-thing-at-point 'word)))
    (if (eq nil efo-abbrev-cache)
        (setq defun-abbrevs (efo-create-abbrev-cache))
      (setq defun-abbrevs efo-abbrev-cache))
    (delete-region (car bounds) (cdr bounds))
    (insert "(" (car (ht-get defun-abbrevs abbrev)) " )")))

(defun efo-create-abbrev-cache (&optional vector-of-symbols)
  (let ((defun-abbrevs (ht-create)))
    (if (string= "vector"(type-of vector-of-symbols))
        (mapcar (efo-add-pair-to-hash) vector-of-symbols)
      (mapatoms (efo-add-pair-to-hash)))
    defun-abbrevs))

(defmacro efo-add-pair-to-hash ()
  (lambda (symbol)
    (if (fboundp symbol)
        (let ((symbol-abbrev (efo-symbol-to-abbrev symbol))
              (sym-name (symbol-name symbol)))
          (ht-set defun-abbrevs
                  symbol-abbrev
                  (cons sym-name
                        (ht-get defun-abbrevs symbol-abbrev)))))))

(defun efo-symbol-to-abbrev (symbol)
  (let ((symbol (symbol-name symbol))
        (dash "fnStartsWithDash"))
    (setq symbol (replace-regexp-in-string "^--" (concat dash "-") symbol))
    (mapconcat (lambda (it)
                 (cond
                  ((string= it "") "-")
                  ((string= it dash) "-")
                  (t (substring it 0 1))))
               (s-split "-+" symbol) "")))

(setq efo-abbrev-cache (efo-create-abbrev-cache))
;; (global-set-key (kbd "C-c M-/") 'efo-expand-abbrev-at-point)

(provide 'efo)
