;; ------------------------------------------------------------
;;; Note:
;; Stuff removed from visual-basic-mode.el
;; ------------------------------------------------------------

;; (defun visual-basic-insert-item ()
;;   "Insert a new item in a block.

;; This function is under developement, and for the time being only
;; Dim and Case items are handled.

;; Interting an item means:

;; * Add a `Case' or `Case Else' into a `Select ... End Select'
;;   block. **under construction** Pressing again toggles between
;;   `Case' and `Case Else'. `Case Else' is possible only if there
;;   is not already a `Case Else'.

;; * Split a Dim declaration over several lines. Split policy is
;;   that:

;;   - the split always occur just before or just after the
;;     declaration of the variable V such that the pointer is
;;     located over this declaration. For instance if the
;;     declaration is `V(2) as T' then pointer position maybe any
;;     `^' as follows:

;;        Dim X, V(2) As T, Y
;;               ^^^^^^^^^^^

;;   - the split being after or before `V(2) as T' decalration and
;;     the position of pointer after split depends on where the
;;     pointer was before the split:

;;     - if the pointer is over variable name (but with array size
;;       inclusive) like this:

;;        Dim X, V(2) As T, Y
;;               ^^^^

;;       then the split is as follows (split is before declaration
;;       and pointer goes to next line):

;;        Dim X
;;        Dim V(2) As T, Y
;;            ^

;;     - if the pointer is not over variable name like this:


;;        Dim X, V(2) As T, Y
;;                   ^^^^^^^

;;       then the split is as follows (split is after declaration
;;       and pointer remains on same line):

;;        Dim X, V(2) As T
;;                        ^
;;        Dim Y

;; * **under construction** Add an `Else' or `ElseIf ... Then' into
;;   an `If ... Then ... End If' block.  Pressing again toggles
;;   between `Else' and `ElseIf ... Then'.  `Else' is possible only
;;   if therei s not already an `Else'."
;;   (interactive)
;;   ;; possible cases are

;;   ;; dim-split-before => pointer remains before `Dim' inserted by split
;;   ;; dim-split-after => pointer goes after `Dim' inserted by split
;;   ;; if-with-else
;;   ;; if-without-else
;;   ;; select-with-else
;;   ;; select-without-else
;;   ;; not-itemizable
;;   (let (item-case
;; 	item-ident
;; 	split-point
;; 	org-split-point
;; 	prefix
;; 	is-const
;; 	tentative-split-point
;; 	block-stack (cur-point (point)) previous-line-of-code)
;;     (save-excursion
;;       (save-match-data
;; 	(beginning-of-line)
;; 	(while
;; 	    (progn
;; 	      (visual-basic-find-original-statement)
;; 	      (cond
;; 	       ;; dim case
;; 	       ;;--------------------------------------------------------------
;; 	       ((and (null previous-line-of-code)
;; 		     (looking-at visual-basic-dim-regexp)
;; 		     (null (save-match-data (looking-at visual-basic-defun-start-regexp))))
;; 		(setq prefix (buffer-substring-no-properties
;; 			      (point)
;; 			      (goto-char (setq split-point (match-end 0)
;; 					       org-split-point split-point)))
;; 		      is-const (string-match "\\_<Const\\_>" prefix)
;; 		      item-case ':dim-split-after)
;; 		;; determine split-point, which is the point at which a new
;; 		;; Dim item is to be inserted. To that purpose the line is gone through
;; 		;; from beginning until cur-point is past
;; 		(while
;;                     (if
;; 			(looking-at "\\(\\s-*\\)\\(?:\\sw\\|\\s_\\)+\\s-*"); some symbol
;; 			(if (>  (setq tentative-split-point (match-end 0)) cur-point)
;;                             (progn
;; 			      (setq item-case (if (>= cur-point (match-end 1))
;; 						  ':dim-split-after
;;                                                 ':dim-split-before))
;; 			      nil;; stop loop
;; 			      )
;; 			  (goto-char tentative-split-point)
;; 			  (setq item-case ':dim-split-before)
;; 			  (let ((loop-again t))
;; 			    (while
;; 				(or
;; 				 ;; array variable
;; 				 (when (looking-at "\\(([^)\n]+)\\)\\s-*")
;;                                    (if (< cur-point (match-end 1))
;;                                        (setq item-case ':dim-split-after
;;                                              loop-again nil)
;;                                      t))
;; 				 ;; continuation
;; 				 (and loop-again
;; 				      (visual-basic-at-line-continuation) ))
;;                               (goto-char (setq tentative-split-point (match-end 0))))
;; 			    (when loop-again
;; 			      (when (looking-at "As\\s-+\\(?:\\sw\\|\\s_\\)+\\s-*")
;; 				(setq item-case ':dim-split-after)
;; 				(goto-char (setq tentative-split-point (match-end 0))))
;; 			      (when (visual-basic-at-line-continuation)
;; 				(beginning-of-line 2))
;; 			      (if (looking-at ",")
;; 				  (goto-char (setq split-point (match-end 0)))
;; 				(setq split-point (point))
;; 				nil))))
;; 		      nil))
;; 		;; now make the split. This means that some comma may need to be deleted.
;; 		(goto-char split-point)
;; 		(looking-at "\\s-*")
;; 		(delete-region split-point (match-end 0))
;; 		(cond
;; 		 ((looking-back ",")
;; 		  (while
;; 		      (progn
;; 			(delete-region split-point
;;                                        (setq split-point (1- split-point)))
;; 			(looking-back "\\s-" (line-beginning-position)))))
;; 		 ((= split-point org-split-point)
;; 		  (insert " ")
;; 		  (setq split-point (point))))
;; 		(insert "\n" prefix " ")
;; 		(setq cur-point (point))
;; 		nil)

;; 	       ;;  case of Case (in Select ... End Select)
;; 	       ;;----------------------------------------------------------------------
;; 	       ((looking-at visual-basic-case-regexp)
;; 		(if (looking-at visual-basic-case-else-regexp)
;; 		    ;; if within a Case Else statement, then insert
;; 		    ;; a Case just before with same indentation
;; 		    (let ((indent (current-indentation)))
;; 		      (beginning-of-line)
;; 		      (insert "Case ")
;; 		      (visual-basic-indent-to-column indent)
;; 		      (setq item-case ':select-with-else
;; 			    split-point (point))
;; 		      (insert ?\n))
;; 		  (setq item-case ':select-without-else))
;; 		nil; break loop
;; 		)

;; 	       ;; next
;; 	       ((looking-at visual-basic-next-regexp)
;; 		(push (list 'next) block-stack))
;; 	       ;; default
;; 	       ;;--------------------------------------------------------------
;; 	       (t (if (bobp)
;; 		      (setq item-case 'not-itemizable)))
;; 	       )
;; 	      (when (null item-case)
;; 		(visual-basic-previous-line-of-code)
;; 		(setq previous-line-of-code t))
;; 	      (null item-case)))))
;;     (cl-case item-case
;;       ((:dim-split-after)   (message "split after") (goto-char cur-point))
;;       ((:dim-split-before)  (message "split before") (goto-char split-point))
;;       ((:select-with-else)  (goto-char split-point))
;;       ((:select-without-else)
;;        ;; go forward until the End Select or next case is met in order to
;;        ;; to insert the new case at this position
;;        (let ((select-case-depth 0))
;; 	 (while
;; 	     (progn
;; 	       (visual-basic-next-line-of-code)
;;                (cond
;; 		;; case was found, insert case and exit loop
;; 		((and (= 0 select-case-depth)
;; 		      (looking-at visual-basic-case-regexp))
;; 		 (let ((indent (current-indentation)))
;; 		   (beginning-of-line)
;; 		   (insert "Case ")
;; 		   (visual-basic-indent-to-column indent)
;; 		   (save-excursion (insert ?\n))
;; 		   nil))
;; 		((looking-at visual-basic-select-regexp)
;; 		 (setq select-case-depth (1+ select-case-depth))
;; 		 (if
;; 		     (re-search-forward (concat visual-basic-select-regexp
;; 						"\\|"
;; 						visual-basic-select-end-regexp)
;; 					nil nil)
;; 		     (progn
;; 		       (beginning-of-line)
;; 		       t ; loop again
;; 		       )
;; 		   (let ((l (line-number-at-pos)))
;; 		     (goto-char cur-point)
;; 		     (error "Select Case without matching end at line %d" l))))
;; 		((looking-at visual-basic-select-end-regexp)
;; 		 (setq select-case-depth (1- select-case-depth))
;; 		 (if (= select-case-depth -1)
;; 		     (let ((indent (current-indentation)))
;; 		       (insert  "Case ")
;; 		       (save-excursion (insert ?\n ))
;; 		       (visual-basic-indent-to-column
;; 		        (+ indent visual-basic-mode-indent))
;; 		       nil;; break loop
;;                        )
;; 		   t; loop again
;;                    ))
;; 		((eobp)
;; 		 (goto-char cur-point)
;; 		 (error "Case without ending"))
;; 		;; otherwise loop again
;; 		(t t)))))) ; end of select-case-without-else
;;       )))

;;; Some experimental functions

;;; Load associated files listed in the file local variables block
(defun visual-basic-load-associated-files ()
  "Load files that are useful to have around when editing the
source of the file that has just been loaded.  The file must have
a local variable that lists the files to be loaded.  If the file
name is relative it is relative to the directory containing the
current buffer.  If the file is already loaded nothing happens,
this prevents circular references causing trouble.  After an
associated file is loaded its associated files list will be
processed."
  (if (boundp 'visual-basic-associated-files)
      (let ((files visual-basic-associated-files)
            (file nil))
        (while files
          (setq file (car files)
                files (cdr files))
          (message "Load associated file: %s" file)
          (visual-basic-load-file-ifnotloaded file default-directory)))))



(defun visual-basic-load-file-ifnotloaded (file default-directory)
  "Load file if not already loaded.
If FILE is relative then DEFAULT-DIRECTORY provides the path."
  (let((file-absolute (expand-file-name file default-directory)))
    (if (get-file-buffer file-absolute); don't do anything if the buffer is already loaded
        ()
      (find-file-noselect file-absolute ))))

;; (defvar hl-line-face)
;; (defun visual-basic-check-style ()
;;   "Check coding style of currently open buffer, and make
;; corrections under the control of user.

;; This function is under construction"
;;   (interactive)
;;   (cl-flet
;;       ((insert-space-at-point
;; 	()
;; 	(insert " "))
;;        ;; avoid to insert space inside a floating point number
;;        (check-plus-or-minus-not-preceded-by-space-p
;; 	()
;; 	(save-match-data
;; 	  (and
;; 	   (visual-basic-in-code-context-p)
;; 	   (null (looking-back "\\([0-9]\\.\\|[0-9]\\)[eE]")))))
;;        (check-plus-or-minus-not-followed-by-space-p
;; 	()
;; 	(save-match-data
;; 	  (and
;; 	   (visual-basic-in-code-context-p)
;; 	   (null  (looking-at "\\(\\sw\\|\\s_\\|\\s\(\\|[.0-9]\\)"))
;; 	   (null (looking-back "\\([0-9]\\.\\|[0-9]\\)[eE]\\|,\\s-*\\(\\|_\\s-*\\)\\|:=\\s-*" (line-beginning-position))))))
;;        (check-comparison-sign-not-followed-by-space-p
;; 	()
;; 	(save-match-data
;; 	  (and
;; 	   (visual-basic-in-code-context-p)
;; 	   (let ((next-char (match-string 2))
;; 		 (str--1 (or (= (match-beginning 1) (point-min))
;; 			     (buffer-substring-no-properties (1- (match-beginning 1))
;; 							     (1+ (match-beginning 1))))))
;; 	     (null (or
;; 		    (and (stringp str--1)
;; 			 (string= str--1 ":="))
;; 		    (string-match "[<=>]" next-char ))) ))));
;;        (replace-by-&
;; 	()
;; 	(goto-char (1- (point)))
;; 	(let* ((p1 (point))
;; 	       (p2 (1+ p1)))
;; 	  (while (looking-back "\\s-" (line-beginning-position))
;; 	    (goto-char (setq p1 (1- p2))))
;; 	  (goto-char p2)
;; 	  (when (looking-at "\\s-+")
;; 	    (setq p2 (match-end 0)))
;; 	  (delete-region p1 p2)
;; 	  (insert " & ")));
;;        (check-string-concatenation-by-+
;; 	()
;; 	(save-match-data
;; 	  (and
;; 	   (visual-basic-in-code-context-p)
;; 	   (or
;; 	    (looking-at "\\s-*\\(\\|_\n\\s-*\\)\"")
;; 	    (looking-back "\"\\(\\|\\s-*_\\s-*\n\\)\\s-*\\+"
;;                           (line-beginning-position)))))))
;;     (let (vb-other-buffers-list
;; 	  ;; list of found error styles
;; 	  ;; each element is a list (POSITION PROMPT ERROR-SOLVE-HANDLER)
;; 	  next-se-list
;; 	  next-se
;; 	  case-fold-search
;; 	  (hl-style-error (make-overlay 1 1)); to be moved
;; 	  (style-errors
;; 	   '(
;; 	     ;; each element is a vector
;; 	     ;;   0	 1	2	3	  4		      5		    6
;; 	     ;; [ REGEXP PROMPT GET-POS RE-EXP-NB ERROR-SOLVE-HANDLER ERROR-CONFIRM LEVEL]
;; 	     [ "\\(\\s\)\\|\\sw\\|\\s_\\)[-+]"
;; 	       "Plus or minus not preceded by space"
;; 	       match-end 1
;; 	       insert-space-at-point
;; 	       check-plus-or-minus-not-preceded-by-space-p
;; 	       0 ]
;; 	     [ "\\(\\s\)\\|\\sw\\|\\s_\\)[/\\*&]"
;; 	       "Operator not preceded by space"
;; 	       match-end 1
;; 	       insert-space-at-point
;; 	       visual-basic-in-code-context-p
;; 	       0 ]
;; 	     [ "[/\\*&]\\(\\s\(\\|\\sw\\|\\s_\\|\\s.\\)"
;; 	       "Operator not followed by space"
;; 	       match-beginning 1
;; 	       insert-space-at-point
;; 	       visual-basic-in-code-context-p
;; 	       0 ]
;; 	     [ "[-+]\\(\\s\(\\|\\sw\\|\\s_\\|\\s.\\)"
;; 	       "Plus or minus not followed by space"
;; 	       match-beginning 1
;; 	       insert-space-at-point
;; 	       check-plus-or-minus-not-followed-by-space-p
;; 	       0 ]
;; 	     [ "\\(\\s\)\\|\\sw\\|\\s_\\)\\(=\\|<\\|>\\)"
;; 	       "Comparison sign not preceded by space"
;; 	       match-end 1
;; 	       insert-space-at-point
;; 	       visual-basic-in-code-context-p
;; 	       0 ]
;; 	     [ "\\(=\\|<\\|>\\)\\(\\s\(\\|\\sw\\|\\s_\\|\\s.\\)"
;; 	       "Comparison sign not followed by space"
;; 	       match-end 1
;; 	       insert-space-at-point
;; 	       check-comparison-sign-not-followed-by-space-p
;; 	       0 ]
;; 	     [ ",\\(\\sw\\|\\s_\\)"
;; 	       "Comma not followed by space"
;; 	       match-beginning 1
;; 	       insert-space-at-point
;; 	       visual-basic-in-code-context-p
;; 	       0 ]
;; 	     [ "\\+"
;; 	       "String should be concatenated with & rather than with +"
;; 	       match-end 0
;; 	       replace-by-&
;; 	       check-string-concatenation-by-+
;; 	       0 ]
;; 	     )); end of style error types
;; 	  )
;;       (condition-case nil 
;; 	  (progn
;; 	    (overlay-put hl-style-error 'face hl-line-face)
;; 	    (overlay-put hl-style-error 'window (selected-window))
;; 	    (dolist (x (buffer-list))
;; 	      (if (and (with-current-buffer x
;; 			 (derived-mode-p 'visual-basic-mode))
;; 		       (null (eq x (current-buffer))))
;; 		  (push x vb-other-buffers-list)))
;; 	    (save-excursion
;; 	      (save-restriction
;; 		(widen)
;; 		(goto-char (point-min))
;; 		(while
;; 		    (progn
;; 		      (setq next-se-list nil)
;; 		      (dolist (se style-errors)
;; 			(save-excursion
;; 			  (when
;; 			      (and
;; 			       (re-search-forward (aref se 0) nil t)
;; 			       (progn
;; 				 (goto-char  (funcall (aref se 2)
;; 						      (aref se 3)))
;; 				 (or (null (aref se 5))
;; 				     (funcall  (aref se 5))
;; 				     (let (found)
;; 				       (while (and
;; 					       (setq found (re-search-forward (aref se 0) nil t))
;; 					       (null (progn
;; 						       (goto-char  (funcall (aref se 2)
;; 									    (aref se 3)))
;; 						       (funcall  (aref se 5))))))
;; 				       found))))
;; 			    (push (list (point)
;; 					(match-beginning 0) 
;; 					(match-end 0)
;; 					(aref se 1)
;; 					(and (> (aref se 6) visual-basic-auto-check-style-level)
;; 					     (aref se 4)))
;; 				  next-se-list))))
;; 		      (when next-se-list
;; 			(setq next-se-list
;; 			      (sort next-se-list (lambda (x y) (< (car x) (car y))))
;; 			      next-se (pop next-se-list))
;; 			(goto-char (pop next-se))
;; 			(move-overlay hl-style-error (pop next-se) (pop next-se))
;; 			(when (y-or-n-p (concat (pop next-se)
;; 						", solve it ? "))
;; 			  (funcall (pop next-se)))
;; 			t; loop again
;; 			))))) )
;; 	;; error handlers
;; 	(delete-overlay hl-style-error))
;;       (delete-overlay hl-style-error)))
;;   (message "Done Visual Basic style check"))
