;;; mbledger.el --- A mode for editing ledger journals


;;; Commentary:
;; 

;;; Code:


;;;###autoload
(define-derived-mode mbledger-mode text-mode "MBLedger"
  "A mode for editing ledger journals."
  ;; :syntax-table mbledger-mode-syntax-table
  :group 'mbledger
  (set (make-local-variable 'comment-start) "; ")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'font-lock-defaults)
       '(mbledger-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'mbledger-indent-line)
  (set (make-local-variable 'indent-tabs-mode) nil)
  (set (make-local-variable 'hippie-expand-try-functions-list) '(mbledger-try-expand)))

(let ((map mbledger-mode-map))
  (define-key map [backtab] 'mbledger-align-amount))


(defcustom mbledger-transaction-indent 8
  "Indentation for transactions."
  :type 'integer
  :group 'mbledger)

(defcustom mbledger-amount-alignment-column 52
  "The column to right align last digit of the amounts at."
  :type 'integer
  :group 'mbledger)



(defface mbledger-account
  '((t (:inherit font-lock-keyword-face)))
  "Account name face"
  :group 'mbledger)
(setq mbledger-account-face 'mbledger-account)

(defface mbledger-uncleared-post
  '((t (:bold t)))
  "Uncleared post face"
  :group 'mbledger)
(setq mbledger-uncleared-post-face 'mbledger-uncleared-post)

(defface mbledger-tag
  '((t :inherit font-lock-constant-face))
  "Tag face"
  :group 'mbledger)
(setq mbledger-tag-face 'mbledger-tag)

(defface mbledger-special
  '((t :inherit font-lock-function-name-face))
  "Special posts"
  :group 'mbledger)
(setq mbledger-special-face 'mbledger-special)



(defconst mbledger-date-regexp
  (let ((sep '(or ?- (any ?. ?/))))
    (rx (group (? (= 4 num)
                  (eval sep))
               (: num (? num))
               (eval sep)
               (: num (? num)))))
  "Regexp matching a date in beginning of a line.")

(defconst mbledger-account-regexp
  (rx bol
      (+ blank)
      (? (any ?* ?!)
         (+ blank))
      (? (any ?\[ ?\())
      (group (+? (not (any ?\] ?\) ?\n ?\;))))
      (? (any ?\] ?\)))
      (or "  " " \t" "\t" eol))
  "Regexp matching an account name possible prefixed with a
  clearance status.")

(defconst mbledger-amount-regexp
  (rx (not (any whitespace))
      (or "  " " \t" "\t")
      (group (* blank))                 ; Indentation
      (? ?-)
      (? (+ (or alpha ?$))
         (* " "))
      (group (? ?-)                     ; The amount
             digit
             (*? (or digit ?. ?,)))
      (? (or ?. ?,)
         (** 1 3 digit))
      (or blank ?\n alpha nonascii)))

(defconst mbledger-post-regexp
  (macroexpand
   `(rx bol
        (regexp ,mbledger-date-regexp)  ; Actual date
        (? "="
           (regexp ,mbledger-date-regexp)) ; Effective date
        (? (+ blank)
           (group (? ?*)))              ; Cleared flag
        (? (+ blank)
           ?\(
           (group (+? nonl))            ; Cheque number
           ?\))
        (+ blank)
        (group (*? nonl))               ; Payee
        (or "  " " \t" "\t" eol))))

(defconst mbledger-uncleared-post-regexp
  (macroexpand
   `(rx bol
        (regexp ,mbledger-date-regexp)
        (? "="
           (regexp ,mbledger-date-regexp))
        (? (+ blank)
           ?\(
           (+? nonl)
           ?\)
           (+ blank))
        (+ blank)
        (group (*? (not (any ?*))))
        (or "  " " \t" "\t" eol))))

(defconst mbledger-tag-regexp
  (rx (any ?\; blank)
      (group (? ?:)
             (+ (not (any " " "\t" "\n")))
             ?: (? ?:))
      (or (any " " "\t") eol)))

(defvar mbledger-font-lock-keywords
  `((,mbledger-account-regexp 1 mbledger-account-face)
    ;; (,mbledger-post-regexp (4 mbledger-account-face))
    (,mbledger-uncleared-post-regexp 3 mbledger-uncleared-post-face)
    (,(rx bol
          (any ?= ?~ letter)
          (+ nonl))
     0 mbledger-special-face)
    (,(rx ?\; (* nonl))
     (0 font-lock-comment-face)
     (,mbledger-tag-regexp
      (progn (beginning-of-line)
             (search-forward ";")
             (backward-char))
      nil
      (1 mbledger-tag-face t))))
  "Expressions to highlight in Ledger mode.")

(defun mbledger-indent-line ()
   "Indent current line."
   (interactive)
   (let ((savep (> (current-column) (current-indentation)))
         (indent (condition-case nil (max (mbledger-calculate-indentation) 0)
                   (error 0))))
     (if savep
         (save-excursion (indent-line-to indent))
       (indent-line-to indent))))

(defun mbledger-calculate-indentation ()
  "Return the column to which the current line should be indented."
  (let ((indent 0))
    (save-excursion
      (beginning-of-line)
      (unless (bobp)
        (forward-line -1)
        (cond ((or (looking-at mbledger-date-regexp)
                   (looking-at "^[~=]"))
               (setq indent mbledger-transaction-indent))
              ((looking-at "^[ \t]+[^;]")
               (setq indent (current-indentation))))))
    indent))

(defvar mbledger-account-tree nil
  "A tree of account names.")

(defun mbledger-find-accounts ()
  "Search the file for account names. Account names will the
saved in the variable `mbledger-account-tree' as a tree of
account name parts. Matches with the point inside will be
excluded."
  (interactive)
  (let ((origin (point)) account-path elements)
    (save-excursion
      (setq mbledger-account-tree (list nil))
      (goto-char (point-min))
      (while (re-search-forward mbledger-account-regexp nil t)
        (unless (and (>= origin (match-beginning 0))
                     (<= origin (match-end 0)))
          (setq account-path (match-string-no-properties 1))
          (setq elements (split-string account-path ":"))
          (let ((root mbledger-account-tree))
            (while elements
              (let ((entry (assoc (car elements) root)))
                (if entry
                    (setq root (cdr entry))
                  (if (cdr elements)
                      (setq entry (list (car elements) (list (car (cdr elements)))))
                    (setq entry (list (car elements))))
                  (nconc root (list entry))
                  (setq root (cdr entry))))
              (setq elements (cdr elements)))))))))

(defun he-mbledger-account-beg ()
  "Return the point of the beginning of the account name on the
current line. If no account name is found return the point at the
beginning of the preceeding word."
  (interactive)
  (let (p)
    (save-excursion
      (beginning-of-line)
      (when (re-search-forward mbledger-account-regexp (point-at-bol 2) t)
        (setq p (match-beginning 1))))
    (unless p
      (save-excursion
        (backward-word 1)
        (setq p (point))))
    p))

(defun mbledger-string-match-predicate (a b)
  "Return non-nil if `a' is a substring of `b' and `a' is in the
beginning `b'. If `a' is an empty string return a non-nil value."
  (or (string= "" a)
      (and (<= (length a) (length b))
           (string= a (substring b 0 (length a))))))

(defun mbledger-tree-to-list (tree sep)
  "Return a list with all possible values with each node joined
by `sep'."
  (let (result)
    (loop for elem in tree
          do (if (null result)
                 (setq result (list (car elem)))
               (nconc result (list (car elem))))
          (when (cdr elem)
            (nconc result
                   (mapcar (lambda (a)
                             (concat (car elem) sep a))
                           (mbledger-tree-to-list (cdr elem) sep)))))
    result))

(defun mbledger-account-completions (string predicate what)
  "Return a list of possible account name completions of
`string'. If `predicate' is non-nil use that as a function for
comparing strings. `what' is ignored."
  (let (elements parents cur (root mbledger-account-tree))
    (setq elements (split-string string ":"))
    (setq parents (butlast elements 1))
    (setq cur (car (last elements)))
    (let ((temp parents))
      (while (let ((entry (assoc (car temp) root)))
               (when entry
                   (setq root (cdr entry))))
        (setq temp (cdr temp))))
    (unless predicate
      (setq predicate 'mbledger-string-match-predicate))
    (let ((prefix (mapconcat 'identity parents ":"))
          (matches (remove-if-not (lambda (a) (funcall predicate cur a))
                                  (mbledger-tree-to-list root ":"))));(mapcar 'car root))))
      (if (string= "" prefix)
          matches
        (mapcar (lambda (a) (concat prefix ":" a)) matches)))))

(defun mbledger-try-expand (old)
  "Hippie Expand function for completing account names."
  (unless old
    (mbledger-find-accounts)
    (he-init-string (he-mbledger-account-beg) (point))
    (setq he-expand-list (sort
                          (all-completions he-search-string 'mbledger-account-completions)
                          'string-lessp)))
  (while (and he-expand-list
              (he-string-member (car he-expand-list) he-tried-table))
    (setq he-expand-list (cdr he-expand-list)))
  (if (null he-expand-list)
      (progn
        (when old (he-reset-string))
        ())
    (he-substitute-string (car he-expand-list))
    (setq he-tried-table (cons (car he-expand-list) (cdr he-tried-table)))
    (setq he-expand-list (cdr he-expand-list))
    t))

(defun mbledger-align-amount (&optional column)
  (interactive "p")
  (when (or (null column) (= column 1))
    (setq column mbledger-amount-alignment-column))
  (save-excursion
    (beginning-of-line)
    (when (re-search-forward mbledger-amount-regexp (point-at-eol) t)
      (let (col offset)
        (goto-char (match-end 2))
        (setq col (current-column))
        (setq offset (- column col))
        (goto-char (match-end 1))
        (if (> offset 0)
            (insert-char ?  offset)
          (setq offset (max (* -1 (length (match-string 1))) offset))
          (delete-char offset))))))

(provide 'mbledger)

;;; mbledger.el ends here
