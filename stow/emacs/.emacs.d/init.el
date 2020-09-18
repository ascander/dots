;;; init.el --- My Emacs configuration               -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Ascander Dost

;; Author: Ascander Dost
;; Keywords: convenience, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This is my Emacs config. There are many like it, but this one is mine.

;;; Code:

;; Constants

(defconst is-a-mac-p (eq system-type 'darwin) "Are we on MacOS?")

(defconst minibuffer-maps
  '(minibuffer-local-map
    minibuffer-local-ns-map
    minibuffer-local-completion-map
    minibuffer-local-must-match-map
    minibuffer-local-isearch-map
    evil-ex-completion-map)
  "List of minibuffer keymaps.")

;; Functions

(defun ad:disable-line-numbers ()
  "Disable line numbers."
  (display-line-numbers-mode -1))

;; Preliminaries

(setq debug-on-error t)                 ; Enter debugger on error
(setq message-log-max 10000)            ; Keep more log messages

;; Startup tuning

;; Set GC threshold as high as possible for fast startup
(setq gc-cons-threshold most-positive-fixnum)

;; Set GC threshold back to default value when Emacs is idle
(run-with-idle-timer 5 nil
             (lambda ()
               (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value)))
               (message "GC threshold restored to %S" gc-cons-threshold)))

;; Print a message after startup
(add-hook 'after-init-hook
      (lambda ()
        (message "Emacs ready in %s with %d garbage collections."
             (format "%.2f seconds"
                 (float-time (time-subtract after-init-time before-init-time)))
             gcs-done)))

;; Package initialization

(require 'package)
(package-initialize 'noactivate)
(eval-when-compile
  (require 'use-package))

;; General

(use-package general
  :demand t)

;; Set aliases for General.el versions
(eval-and-compile
  (defalias 'gsetq #'general-setq)
  (defalias 'gsetq-default #'general-setq-default)
  (defalias 'gsetq-local #'general-setq-local))

;; General bindings take precedence
(general-auto-unbind-keys)

;; Leader keys

(general-create-definer general-spc	; Buffer/file/group management
  :states 'normal
  :keymaps 'override
  :prefix "SPC")

(general-create-definer general-t	; Window navigation/management
  :states 'normal
  :keymaps 'override
  :prefix "t")

(general-create-definer general-m	; Major mode functionality
  :states 'normal
  :prefix "m")

(general-create-definer general-r	; Remapped bindings
  :states 'normal
  :prefix "r")

;; Evil & Evil Collection

(use-package evil
  :init
  (gsetq evil-want-keybinding nil ; don't load evil bindings for other modes
     evil-overriding-maps nil ; no maps should override evil maps
     evil-search-module 'evil-search ; use evil-search instead of isearch (remapped)
     evil-exsearch-persistent-highlight nil ; no persistent highlighting of search matches
     evil-want-Y-yank-to-eol t)		; make 'Y' behave like 'D'
  :config (evil-mode))

(use-package evil-collection
  :demand t
  :after evil
  :init (gsetq evil-collection-company-use-tng nil)
  :config (evil-collection-init))

;; Default Evil Bindings

;; Swap some default Evil bindings
(general-def 'normal
  "a" #'evil-append-line
  "A" #'evil-append
  ";" #'evil-ex)

;; Move lost bindings to 'r' leader
(general-r
 ";" #'evil-repeat-find-char
 "/" #'evil-ex-search-forward)

;; Default Evil states

;; Exit emacs state with "ESC"
(general-def 'emacs
  "<escape>" #'evil-normal-state)

;; Use normal state as the default state for all modes
(general-with 'evil
  (gsetq evil-normal-state-modes (append evil-emacs-state-modes
                     evil-normal-state-modes)
     evil-emacs-state-modes nil
     evil-motion-state-modes nil))

;; Bind "ESC" to quit minibuffers as often as possible

(general-def :keymaps minibuffer-maps
  "<escape>" #'keyboard-escape-quit)

;; Which-key

(use-package which-key
  :init
  (gsetq which-key-idle-delay 0.3
     which-key-idle-secondary-delay 0.2
     which-key-sort-order 'which-key-prefix-then-key-order-reverse
     which-key-max-display-columns 6
     which-key-add-column-padding 2)
  :config
  ;; Set replacements for the 'which-key' UI
  (gsetq which-key-replacement-alist '((( nil . "Prefix Command") . (nil . "prefix"))
                       ((nil . "\\`\\?\\?\\'")    . (nil . "λ"))
                       ((nil . "magit-")          . (nil . "git-"))))

  ;; Disable line numbers in which-key buffers
  (general-add-hook 'which-key-init-buffer-hook #'ad:disable-line-numbers)

  (which-key-mode))

;; Company

(use-package company
  :init
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 1
        company-tooltip-limit 12
        company-show-numbers t
        company-tooltip-align-annotations t)
  :hook (after-init . global-company-mode))

;; LSP

(use-package lsp-mode
    :hook ((scala-mode . lsp-deferred)
       (lsp-mode   . lsp-enable-which-key-integration))
    :commands lsp lsp-deferred
    :init
    ;; Disable automatic modes that throw errors on lazy loading
    (setq lsp-enable-dap-auto-configure nil
        lsp-modeline-diagnostics-enable nil
        lsp-modeline-code-actions-enable nil)

    ;; Performance tuning
    (gsetq lsp-completion-provider :capf
       lsp-idle-delay 0.5
       read-process-output-max (* 1024 1024))
    :config
    ;; Bind the most commonly used LSP commands directly
    (general-def 'normal lsp-mode-map
      "N" #'lsp-describe-thing-at-point
      "RET" #'lsp-find-definition)

    ;; Bind LSP command map to our major mode leader
    (gsetq lsp-keymap-prefix "mm")
    (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)

    ;; Bind some additional LSP commands; note "mm" should still bring
    ;; up the 'which-key' enabled `lsp-command-map'
    (general-m lsp-mode-map
      "m" lsp-command-map
      "a" #'lsp-execute-code-action
      "v" #'lsp-avy-lens
      "i" #'lsp-goto-implementation
      "D" #'lsp-find-declaration
      "T" #'lsp-find-type-definition
      ;; cross (x) references
      "x" #'lsp-find-references
      "r" #'lsp-rename
      "R" #'lsp-restart-workspace
      "=" #'lsp-format-buffer
      "l" #'lsp-workspace-show-log))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  ;; Style 'lsp-ui' documentation on hover
  (gsetq lsp-ui-doc-enable t
     lsp-ui-doc-position 'top
     lsp-ui-doc-max-width 120
     lsp-ui-doc-max-height 40
     lsp-ui-doc-use-webkit t))

;; Scala

(use-package scala-mode
  :mode ("\\.scala\\'" "\\.sbt\\'"))

(use-package sbt-mode
  :after scala-mode
  :commands sbt-start sbt-command
  :config
  ;; Don't pop up SBT buffers automatically
  (gsetq sbt:display-command-buffer nil)

  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))

(provide 'init)
;;; init.el ends here
