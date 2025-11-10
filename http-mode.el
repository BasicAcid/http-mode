;;; http-mode.el --- Minor mode for HTTP syntax highlighting -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author: David Tabarie
;; Version: 0.1
;; Package-Requires: ((emacs "24.3"))
;; Keywords: http, syntax, highlighting
;; URL: https://github.com/BasicAcid/http-mode

;;; Commentary:

;; This minor mode provides syntax highlighting for plaintext HTTP requests
;; and responses.  It highlights HTTP methods, status codes, headers, and
;; request/response bodies.

;;; Code:

(defgroup http-mode nil
  "Minor mode for HTTP syntax highlighting."
  :group 'languages
  :prefix "http-mode-")

(defface http-mode-method-face
  '((t :inherit font-lock-keyword-face :weight bold))
  "Face for HTTP methods (GET, POST, etc.)."
  :group 'http-mode)

(defface http-mode-version-face
  '((t :inherit font-lock-constant-face))
  "Face for HTTP version (HTTP/1.1, HTTP/2, etc.)."
  :group 'http-mode)

(defface http-mode-uri-face
  '((t :inherit font-lock-function-name-face))
  "Face for URIs in request lines."
  :group 'http-mode)

(defface http-mode-status-code-face
  '((t :inherit font-lock-constant-face :weight bold))
  "Face for HTTP status codes."
  :group 'http-mode)

(defface http-mode-status-text-face
  '((t :inherit font-lock-string-face))
  "Face for HTTP status text."
  :group 'http-mode)

(defface http-mode-header-name-face
  '((t :inherit font-lock-variable-name-face :weight bold))
  "Face for HTTP header names."
  :group 'http-mode)

(defface http-mode-header-value-face
  '((t :inherit font-lock-string-face))
  "Face for HTTP header values."
  :group 'http-mode)

(defface http-mode-body-face
  '((t :inherit default))
  "Face for HTTP message body."
  :group 'http-mode)

(defconst http-mode-methods
  '("GET" "POST" "PUT" "DELETE" "PATCH" "HEAD" "OPTIONS" "CONNECT" "TRACE")
  "List of HTTP methods.")

(defvar http-mode-font-lock-keywords
  `(
    ;; HTTP Request Line: METHOD URI HTTP/VERSION
    (,(concat "^\\(" (regexp-opt http-mode-methods) "\\)"
              "[ \t]+\\([^ \t\n]+\\)"
              "[ \t]+\\(HTTP/[0-9.]+\\)[ \t]*$")
     (1 'http-mode-method-face)
     (2 'http-mode-uri-face)
     (3 'http-mode-version-face))

    ;; HTTP Response Status Line: HTTP/VERSION CODE TEXT
    ("^\\(HTTP/[0-9.]+\\)[ \t]+\\([0-9]+\\)[ \t]+\\(.*\\)$"
     (1 'http-mode-version-face)
     (2 'http-mode-status-code-face)
     (3 'http-mode-status-text-face))

    ;; HTTP Headers: Name: Value
    ("^\\([A-Za-z0-9-]+\\):[ \t]*\\(.*\\)$"
     (1 'http-mode-header-name-face)
     (2 'http-mode-header-value-face)))
  "Font lock keywords for HTTP mode.")

(defun http-mode-font-lock-extend-region ()
  "Extend the font-lock region to include complete HTTP messages."
  (save-excursion
    (goto-char font-lock-beg)
    (let ((found (or (re-search-backward "^\\(?:GET\\|POST\\|PUT\\|DELETE\\|PATCH\\|HEAD\\|OPTIONS\\|CONNECT\\|TRACE\\|HTTP/[0-9.]+\\)" nil t)
                     (point-min))))
      (when found
        (setq font-lock-beg found)))))

;;;###autoload
(define-minor-mode http-mode
  "Minor mode for HTTP syntax highlighting.

This mode provides syntax highlighting for plaintext HTTP requests
and responses, including methods, URIs, status codes, headers, and
message bodies.

\\{http-mode-map}"
  :lighter " HTTP"
  :group 'http-mode
  (if http-mode
      (progn
        (font-lock-add-keywords nil http-mode-font-lock-keywords)
        (add-hook 'font-lock-extend-region-functions
                  'http-mode-font-lock-extend-region nil t))
    (font-lock-remove-keywords nil http-mode-font-lock-keywords)
    (remove-hook 'font-lock-extend-region-functions
                 'http-mode-font-lock-extend-region t))
  (if (fboundp 'font-lock-flush)
      (font-lock-flush)
    (when font-lock-mode
      (with-no-warnings (font-lock-fontify-buffer)))))

;;;###autoload
(add-hook 'find-file-hook
  (lambda ()
    (when (and buffer-file-name
               (string-match-p "\\.\\(http\\|rest\\)\\'" buffer-file-name))
      (http-mode 1))))

(provide 'http-mode)

;;; http-mode.el ends here
