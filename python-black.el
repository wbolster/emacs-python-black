;;; python-black.el --- Reformat Python using python-black -*- lexical-binding: t; -*-

;; Author: wouter bolsterlee <wouter@bolsterl.ee>
;; Keywords: languages
;; URL: https://github.com/wbolster/emacs-python-black
;; Package-Requires: ((emacs "25") (dash "2.16.0") (reformatter "0.3"))
;; Version: 1.0.0

;; Copyright 2019 wouter bolsterlee. Licensed under the 3-Clause BSD License.

;;; Commentary:

;; Commands for reformatting Python code via black (and black-macchiato).

;;; Code:

(require 'dash)
(require 'python)
(require 'reformatter)
(require 'rx)

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

(defconst python-black--config-file "pyproject.toml")
(defconst python-black--config-file-marker-regex (rx bol "[tool.black]" eol))

;;;###autoload (autoload 'python-black-buffer "python-black" nil t)
;;;###autoload (autoload 'python-black-region "python-black" nil t)
;;;###autoload (autoload 'python-black-on-save-mode "python-black" nil t)
(reformatter-define python-black
  :program (python-black--command beg end)
  :args (python-black--make-args beg end)
  :lighter " BlackFMT"
  :group 'python-black)

;;;###autoload
(defun python-black-on-save-mode-enable-dwim ()
  "Enable ‘python-black-on-save-mode’ if appropriate."
  (interactive)
  (-when-let* ((file-name (buffer-file-name))
               (uses-black? (python-black--in-blackened-project-p file-name))
               (not-third-party? (not (python-black--third-party-file-p file-name))))
    (python-black-on-save-mode)))

;;;###autoload
(defun python-black-statement (&optional display-errors)
  "Reformats the current statement.

When called interactively with a prefix argument, or when
DISPLAY-ERRORS is non-nil, shows a buffer if the formatting fails."
  (interactive "p")
  (-when-let* ((beg (save-excursion
                      (python-nav-beginning-of-statement)
                      (line-beginning-position)))
               (end (save-excursion
                      (python-nav-end-of-statement)
                      (line-end-position)))
               (non-empty? (not (= beg end))))
    (python-black-region beg (min (point-max) (1+ end)) display-errors)))

;;;###autoload
(defun python-black-partial-dwim (&optional display-errors)
  "Reformats the active region or the current statement.

This runs ‘python-black-region’ or ‘python-black-statement’ depending
on whether the region is currently active.

When called interactively with a prefix argument, or when
DISPLAY-ERRORS is non-nil, shows a buffer if the formatting fails."
  (interactive "p")
  (if (region-active-p)
      (python-black-region (region-beginning) (region-end) display-errors)
    (python-black-statement display-errors)))

;;;###autoload
(defun python-black-org-mode-block (&optional display-errors)
  "Reformats the current org-mode source block."
  (interactive)
  (unless (org-in-block-p '("src" "example"))
    (user-error "Not in a source block"))
  (save-mark-and-excursion
    (pcase (org-src--contents-area (org-element-at-point))
      (`(,beg ,end ,_)
       (python-black-region beg (- end 1) display-errors)))))

(defun python-black--command (beg end)
  "Helper to decide which command to run for span BEG to END."
  (if (python-black--whole-buffer-p beg end)
      python-black-command
    (unless (executable-find python-black-macchiato-command)
      (error "Partial formatting requires ‘%s’, but it is not installed"
             python-black-macchiato-command))
    python-black-macchiato-command))

(defun python-black--make-args (beg end)
  "Helper to build the argument list for black for span BEG to END."
  (append
   python-black--base-args
   (-when-let* ((file-name (buffer-file-name))
                (extension (file-name-extension file-name))
                (is-pyi-file (string-equal "pyi" extension)))
     '("--pyi"))
   python-black-extra-args
   (when (python-black--whole-buffer-p beg end)
     '("-"))))

(defun python-black--whole-buffer-p (beg end)
  "Return whether BEG and END span the whole buffer."
  (and (= (point-min) beg)
       (= (point-max) end)))

(defun python-black--in-blackened-project-p (file-name)
  "Determine whether FILE-NAME resides in a project that is using Black.

This looks for ‘[tool.black]’ in a ‘pyproject.toml’ file."
  (-when-let* ((project-directory (locate-dominating-file file-name python-black--config-file))
               (config-file (concat project-directory python-black--config-file))
               (config-file-contains-marker
                (with-temp-buffer
                  (insert-file-contents-literally config-file)
                  (re-search-forward python-black--config-file-marker-regex nil t 1))))
    t))

(defun python-black--third-party-file-p (file-name)
  "Determine whether FILE-NAME is likely a third party file."
  (-when-let* ((lib-python-dir (locate-dominating-file file-name "site-packages")))
    t))

(provide 'python-black)
;;; python-black.el ends here
