(require 'sta)

(ert-deftest single-word-symbols-get-added ()
  (should (string= (sta-symbol-to-abbrev 'if) "i"))
  (should (string= (sta-symbol-to-abbrev 'test) "t")))

(ert-deftest simple-symbols-get-added ()
  (should (string= (sta-symbol-to-abbrev 'test-symbol-name) "tsn")))

(ert-deftest dash-dash-symbols-get-added ()
  (should (string= (sta-symbol-to-abbrev '--example-symbol) "-es")))

(ert-deftest duplicate-abbreviations ()
  (flet ((example-defun () ())
         (example-different () ()))
    (let ((example-hash (sta-create-abbrev-cache
                         (vector 'example-defun 'example-different))))
      (should (equal '("example-different" "example-defun")
                     (ht-get example-hash "ed"))))))

(ert-deftest expand-abbrev-with-single-symbol ()
  (with-temp-buffer
    (setq sta-abbrev-cache (ht ("ed" '("example-defun"))))
    (insert "ed")
    (sta-expand-abbrev-at-point)
    (should (equal (thing-at-point 'symbol) "example-defun"))))
