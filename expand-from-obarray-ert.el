(require 'efo)

(ert-deftest single-word-symbols-get-added ()
  (should (string= (efo-symbol-to-abbrev 'if) "i"))
  (should (string= (efo-symbol-to-abbrev 'test) "t")))

(ert-deftest simple-symbols-get-added ()
  (should (string= (efo-symbol-to-abbrev 'test-symbol-name) "tsn")))

(ert-deftest dash-symbols-get-added ()
  (should (string= (efo-symbol-to-abbrev '-example) "-e")))

(ert-deftest dash-dash-symbols-get-added ()
  (should (string= (efo-symbol-to-abbrev '--example-symbol) "-es")))

(ert-deftest duplicate-abbreviations ()
  (flet ((example-defun () ())
         (example-different () ()))
    (let ((example-hash (efo-create-abbrev-cache
                         (vector 'example-defun 'example-different))))
      (should (equal '("example-different" "example-defun")
                     (ht-get example-hash "ed"))))))

(ert-deftest expand-abbrev-with-single-symbol ()
  (with-temp-buffer
    (setq efo-abbrev-cache (ht ("ed" '("example-defun"))))
    (insert "ed")
    (efo-expand-abbrev-at-point)
    (goto-char (point-min))
    (should (equal (thing-at-point 'sexp) "(example-defun )"))))
