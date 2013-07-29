(require 's)
(require 'ht)

;; (global-set-key (kbd "C-c <f5>") (lambda ()
;;                                    (interactive)
;;                                    (compile "emacs -batch -L /Users/dgempesaw/.emacs.d/elpa/ht-0.8/ -L /Users/dgempesaw/.emacs.d/elpa/s-1.6.1/ /opt/dotemacs/elpa/ -L /opt/symbol-to-abbrev/ -l ert -l sta-ert.el -f ert-run-tests-batch-and-exit")))

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

(provide 'sta)
