;;; popup-complete.el --- completion with popup

;; Copyright (C) 2014 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-popup-complete
;; Version: 0.01
;; Package-Requires: ((popup "0.5.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See also
;;  - http://www.emacswiki.org/emacs/PopUp
;;
;; Original code is created by LinhDang
;;

;;; Code:

(require 'popup)

(defgroup popup-complete nil
  "Completion with popup-el"
  :group 'popup)

(defcustom popup-complete-enable t
  "If non-NIL, complete-in-region will popup a menu with the possible completions."
  :type 'boolean
  :group 'popup-complete)

;;;###autoload
(defun popup-complete--in-region (next-func start end collection &optional predicate)
  (if (not popup-complete-enable)
      (funcall next-func start end collection predicate)
    (let* ((prefix (buffer-substring start end))
           (completion (try-completion prefix collection predicate))
           (choice (and (stringp completion)
                        (string= completion prefix)
                        (popup-menu* (all-completions prefix collection predicate))))
           (replacement (or choice completion))
           (tail (and (stringp replacement)
                      (not (string= prefix replacement))
                      (substring replacement (- end start)))))
      (cond ((eq completion t)
             (goto-char end)
             (message "Sole completion")
             nil)
            ((null completion)
             (message "No match")
             nil)
            (tail
             (goto-char end)
             (insert tail)
             t)
            (choice
             (message "Nothing to do")
             nil)
            (t
             (message "completion: something failed!")
             (funcall next-func start end collection predicate))))))

;;;###autoload
(add-hook 'completion-in-region-functions 'popup-complete--in-region)

(provide 'popup-complete)

;;; popup-complete.el ends here
