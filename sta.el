(require 's)
(require 'ht)

;; (global-set-key (kbd "C-c <f5>") (lambda ()
;;                                    (interactive)
;;                                    (compile "emacs -batch -L /Users/dgempesaw/.emacs.d/elpa/ht-0.8/ -L /Users/dgempesaw/.emacs.d/elpa/s-1.6.1/ /opt/dotemacs/elpa/ -L /opt/sta/ -l ert -l sta-ert.el -f ert-run-tests-batch-and-exit")))

(defvar sta-abbrev-cache nil
  "The cache of abbrev => defun relationships")

(defun sta-expand-abbrev-at-point ()
  (interactive)
  (let ((defun-abbrevs)
        (abbrev (thing-at-point 'word))
        (bounds (bounds-of-thing-at-point 'word)))
    (if (eq nil sta-abbrev-cache)
        (setq defun-abbrevs (sta-create-abbrev-cache))
      (setq defun-abbrevs sta-abbrev-cache))
    (delete-region (car bounds) (cdr bounds))
    (insert (car (ht-get defun-abbrevs abbrev)))))

(defun sta-create-abbrev-cache (&optional vector-of-symbols)
  (let ((defun-abbrevs (ht-create)))
    (if (string= "vector"(type-of vector-of-symbols))
        (mapcar (sta-add-pair-to-hash) vector-of-symbols)
      (mapatoms (sta-add-pair-to-hash)))
    defun-abbrevs))

(defmacro sta-add-pair-to-hash ()
  (lambda (symbol)
    (if (fboundp symbol)
        (let ((symbol-abbrev (sta-symbol-to-abbrev symbol))
              (sym-name (symbol-name symbol)))
          (ht-set defun-abbrevs
                  symbol-abbrev
                  (cons sym-name
                        (ht-get defun-abbrevs symbol-abbrev)))))))

(defun sta-symbol-to-abbrev (symbol)
  (let ((symbol (symbol-name symbol))
        (dash "fnStartsWithDash"))
    (setq symbol (replace-regexp-in-string "^--" (concat dash "-") symbol))
    (mapconcat (lambda (it)
                 (cond
                  ((string= it "") "")
                  ((string= it dash) "-")
                  (t (substring it 0 1))))
               (s-split "-+" symbol) "")))

(setq sta-abbrev-cache (sta-create-abbrev-cache))

(provide 'sta)
