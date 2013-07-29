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


(setq sta-defun-abbrevs (sta-create-abbrev-cache))


(setq sta-temp (ht-get sta-defun-abbrevs "scac"))
