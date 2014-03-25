;;; fancy-narrow.el --- narrow-to-region with more eye candy.

;; Copyright (C) 2014 Artur Malabarba <bruce.connor.am@gmail.com>

;; Author: Artur Malabarba <bruce.connor.am@gmail.com>
;; URL: http://github.com/Bruce-Connor/fancy-narrow-region
;; Version: 0.1a
;; Keywords: faces convenience
;; Prefix: fancy-narrow
;; Separator: -

;;; Commentary:
;; 
;; fancy-narrow is a package that immitates narrow-to-region with more
;; eye-candy. Instead of completely hiding text beyond the narrowed
;; region, the text is de-emphasized and becomes unreachable.
;; 
;; Simply call `fancy-narrow-to-region' to see it in action. Remember to
;; `fancy-widen' afterwards.
;; 
;; To change the face used on the blocked text, customise `fancy-narrow-blocked-face'.
;; 
;; Note this is designed for user interaction. For using within lisp code,
;; the standard `narrow-to-region' is preferable, because the fancy
;; version is susceptible to `inhibit-read-only' and some corner cases.

;;; License:
;;
;; This file is NOT part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 

;;; Change Log:
;; 0.1a - 2014/03/17 -  - Created File.
;;; Code:

(defconst fancy-narrow-version "0.1a" "Version of the fancy-narrow-region.el package.")
(defun fancy-narrow-bug-report ()
  "Opens github issues page in a web browser. Please send any bugs you find.
Please include your emacs and fancy-narrow-region versions."
  (interactive)
  (message "Your fancy-narrow-version is: %s, and your emacs version is: %s.\nPlease include this in your report!"
           fancy-narrow-region-version emacs-version)
  (browse-url "https://github.com/Bruce-Connor/fancy-narrow/issues/new"))
(defgroup fancy-narrow nil
  "Customization group for fancy-narrow."
  :prefix "fancy-narrow-")

(defconst fancy-narrow--help-string
  "This region is blocked from editing while buffer is narrowed."
  "Help-echo string displayed on mouse-over.")

(defcustom fancy-narrow-properties
  '(intangible t read-only t
               fontified nil
               font-lock-face fancy-narrow-blocked-face
               help-echo fancy-narrow--help-string
               point-left fancy-narrow--motion-function
               point-entered fancy-narrow--motion-function-enter
               fancy-narrow-this-text-will-be-deleted t)
  "List of properties given to text beyond the narrowed region."
  :type 'list
  :group 'fancy-narrow-region)

(defun fancy-narrow--motion-function (x y)
  "Keep point from going past the boundaries."
  (if (eobp) (forward-char -1)
    (if (bobp) (forward-char 1))))
(defalias 'fancy-narrow--motion-function-enter 'fancy-narrow--motion-function)

;;;###autoload
(defun fancy-narrow-to-region (start end)
  "Like `narrow-to-region', except it still displays the unreachable text."
  (interactive "r")
  (let ((l (min start end))
        (r (max start end)))
    (fancy-narrow--propertize-buffer (point-min) l)
    (fancy-narrow--propertize-buffer r (point-max))))

(defun fancy-narrow--propertize-buffer (l r)
  ""
  (add-text-properties l r fancy-narrow-properties))

(defun fancy-widen ()
  "Undo narrowing from `fancy-narrow-to-region'."
  (interactive)
  (let ((inhibit-point-motion-hooks t)
        (inhibit-read-only t))
    (remove-text-properties (point-min) (point-max) fancy-narrow-properties)))

(defface fancy-narrow-blocked-face
  '((((background light)) :foreground "Grey70")
    (((background dark)) :foreground "Grey30"))
  "Face used on blocked text."
  :group 'fancy-narrow-region)

(provide 'fancy-narrow)
;;; fancy-narrow.el ends here.
