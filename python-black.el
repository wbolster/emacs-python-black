;;; python-black.el --- Reformat Python using python-black -*- lexical-binding: t; -*-

;; Author: wouter bolsterlee <wouter@bolsterl.ee>
;; Keywords: languages
;; URL: https://github.com/wbolster/emacs-python-black
;; Package-Requires: ((emacs "25") (dash "2.16.0") (reformatter "0.3"))
;; Version: 0.1.0

;; Copyright 2019 wouter bolsterlee. Licensed under the 3-Clause BSD License.

;;; Commentary:

;; Commands for reformatting Python code via black (and black-macchiato).

;;; Code:

(require 'dash)
(require 'reformatter)

(defgroup python-black nil
  "Python reformatting using black."
  :group 'python
  :prefix "python-black-")

(defcustom python-black-command "black"
  "Name of the ‘black’ executable."
  :group 'python-black
  :type 'string)

(defcustom python-black-macchiato-command "black-macchiato"
  "Name of the ‘black-macchiato’ executable."
  :group 'python-black
  :type 'string)

(defvar python-black--base-args '("--quiet")
  "Base arguments to pass to black.")

(defcustom python-black-extra-args nil
  "Extra arguments to pass to black."
  :group 'python-black
  :type '(repeat string))

;;;###autoload (autoload 'python-black-buffer "python-black" nil t)
;;;###autoload (autoload 'python-black-region "python-black" nil t)
;;;###autoload (autoload 'python-black-on-save-mode "python-black" nil t)
(reformatter-define python-black
  :program (python-black--command)
  :args (python-black--make-args)
  :lighter " BlackFMT"
  :group 'python-black)

(defun python-black--command ()
  "Helper to decide which command to run."
  (if (python-black--partially-formatting?)
      (progn
        (unless (executable-find python-black-macchiato-command)
          (error "Partial formatting requires ‘%s’, but it is not installed"
                 python-black-macchiato-command))
        python-black-macchiato-command)
    python-black-command))

(defun python-black--make-args ()
  "Helper to build the argument list for black."
  (append
   python-black--base-args
   (-when-let* ((file-name (buffer-file-name))
                (extension (file-name-extension file-name))
                (is-pyi-file (string-equal "pyi" extension)))
     '("--pyi"))
   python-black-extra-args
   (unless (python-black--partially-formatting?)
     '("-"))))

(defun python-black--partially-formatting? ()
  "Return whether this is a partial formatting operation."
  ;; Inspecting a variable like this-command is not useful here,
  ;; since that won't work for the on save hook, and will also fail if
  ;; the function is called indirectly (e.g. by another user-defined
  ;; command). Instead, inspect the current call stack to figure out
  ;; whether python-black-buffer occurs in it.
  (-none? (lambda (frame)
            (let ((func (nth 1 frame)))
              (eq func 'python-black-buffer)))
          (backtrace-frames)))

(provide 'python-black)
;;; python-black.el ends here
