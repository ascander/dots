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

;; Package initialization

(require 'package)
(package-initialize 'noactivate)
(eval-when-compile
  (require 'use-package))

;; General and Evil
(use-package general
  :config
  ;; aliases
  (eval-and-compile
    (defalias 'gsetq #'general-setq)
    (defalias 'gsetq-local #'general-setq-local)
    (defalias 'gsetq-default #'general-setq-default))

  ;; Unbind keys when necessary - General should take precedence
  (general-auto-unbind-keys)

  ;; General leader key
  (general-create-definer general-spc
    :states 'normal
    :keymaps 'override
    :prefix "SPC")

  ;; Window navigation/management, Version control, etc.
  (general-create-definer general-t
    :states 'normal
    :keymaps 'override
    :prefix "t")

  ;; Major mode functionality
  (general-create-definer general-m
    :states 'normal
    :prefix "m")

  ;; Re-mapped bindings from standard Evil
  (general-create-definer general-r
    :states 'normal
    :prefix "r"))

(use-package evil
  :demand t
  :init
  (gsetq evil-want-keybinding nil     ; don't load evil bindings for other modes
         evil-overriding-maps nil     ; no maps should override evil maps
         evil-search-module 'evil-search ; use evil-search instead of isearch
         ;; This setting is not respected for 'n/N' searches.
         ;;
         ;; NOTE: persistent highlighting after a search can be cleared with the
         ;; ':nohlsearch' (evil-ex-nohighlight) command.
         ;;
         ;; See: https://github.com/emacs-evil/evil/pull/1128/commits/68d4eb382fe25db74dd1c5f4ddea00ff249ca254
         evil-ex-search-persistent-highlight nil ; no persistent highlighting after search
         evil-want-Y-yank-to-eol t)              ; Y like D
  :config (evil-mode))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; Swap/change default Evil bindings
(general-def 'normal
  "a" #'evil-append-line                ; append line without holding shift
  "A" #'evil-append                     ; append here for a bit more
  ";" #'evil-ex)                        ; evil-ex without holding shift

;; Replace lost bindings with 'r' prefix
(general-r
  ";" #'evil-repeat-find-char           ; from new 'evil-ex'
  "/" #'evil-ex-search-forward)         ; from swiper

;; Exit emacs state with ESC
(general-def 'emacs
  "<escape>" #'evil-normal-state)

;; Use normal state as the default state for all modes
(gsetq evil-normal-state-modes
       (append evil-emacs-state-modes evil-normal-state-modes)
       evil-emacs-state-modes nil
       evil-motion-state-modes nil)

;; Bind ESC to quit minibuffers as often as possible
(general-def '(minibuffer-local-map
               minibuffer-local-ns-map
               minibuffer-local-completion-map
               minibuffer-local-must-match-map
               minibuffer-local-isearch-map)
  "<escape>" #'keyboard-escape-quit)

;; MacOS specific packages/settings

(when (eq system-type 'darwin)
  (use-package exec-path-from-shell
    :init (gsetq exec-path-from-shell-check-startup-files nil)
    :config (exec-path-from-shell-initialize))

  (use-package osx-trash
    :config (osx-trash-setup))

  (gsetq mac-command-modifier 'meta     ; Command is meta
         mac-option-modifier 'super     ; Alt/Option is super
         mac-function-modifier 'none))  ; Reserve function for macOS

;; Default settings
(gsetq-default
 blink-cursor-mode -1            ; no blinking
 ring-bell-function #'ignore         ; no ringing
 inhibit-startup-screen t            ; no startup screen
 initial-scratch-message ""          ; no message in the scratch buffer
 cursor-in-non-selected-windows nil  ; hide the cursor in inactive windows
 delete-by-moving-to-trash t         ; delete files to trash
 fill-column 80                      ; set width for modern displays
 help-window-select t                ; focus new help windows when opened
 indent-tabs-mode nil                ; stop using tabs to indent
 tab-width 4                         ; but set their width properly
 left-margin-width 0                 ; no left margin
 right-margin-width 0                ; no right margin
 recenter-positions '(12 top bottom) ; set re-centering positions
 scroll-conservatively 1000          ; never recenter point while scrolling
 sentence-end-double-space nil       ; single space after a sentence end
 require-final-newline t             ; require a newline at file end
 show-trailing-whitespace nil        ; don't display trailing whitespaces by default
 uniquify-buffer-name-style 'forward ; uniquify buffer names correctly
 window-combination-resize t         ; resize windows proportionally
 frame-resize-pixelwise t            ; resize frames by pixel (don't snap to char)
 history-length 1000                 ; store more history
 use-dialog-box nil)                 ; don't use dialogues for mouse imput

;; Miscellaneous
(fset 'yes-or-no-p 'y-or-n-p)                      ; replace yes/no prompts with y/n
(fset 'display-startup-echo-area-message #'ignore) ; no startup message in the echo area
(delete-selection-mode 1)                          ; replace region when inserting text
(put 'downcase-region 'disabled nil)               ; enable downcase-region
(put 'upcase-region 'disabled nil)                 ; enable upcase-region
(global-hl-line-mode)                              ; highlight the current line
(line-number-mode)                                 ; display line number in the mode line
(column-number-mode)                               ; display column number in the mode line

;;; Basic UI settings

;; Use Emacs' builtin line numbering
(gsetq-default display-line-numbers 'visual ; vim-style line numbers
               display-line-numbers-widen t ; disregard any narrowing
               display-line-numbers-current-absolute t) ; display absolute number of current line

(defun ad:relative-line-numbers ()
  "Toggle relative line numbers."
  (when (bound-and-true-p display-line-numbers)
    (setq-local display-line-numbers 'visual)))

(defun ad:absolute-line-numbers ()
  "Toggle absolute line numbers."
  (when (bound-and-true-p display-line-numbers)
    (setq-local display-line-numbers t)))

(defun ad:disable-line-numbers-local ()
  "Locally disable line numbers."
  (setq-local display-line-numbers nil))

;; Switch to absolute line numbers in insert state
(general-add-hook 'evil-insert-state-entry-hook #'ad:absolute-line-numbers)
(general-add-hook 'evil-insert-state-exit-hook #'ad:relative-line-numbers)

;; Disable line numbers in terminal-ish modes
(general-add-hook 'comint-mode-hook #'ad:disable-line-numbers-local)
(general-add-hook 'vterm-mode-hook #'ad:disable-line-numbers-local)

;; Go ahead and disable global line highlighting in terminal-ish modes, too
(general-add-hook 'vterm-mode-hook #'(lambda () (gsetq-local global-hl-line-mode nil)))

;; Bedazzle the current line number
;; TODO handle this for dark/light themes
(custom-set-faces
 '(line-number-current-line ((t :weight bold :foreground "#b58900"))))

(use-package no-littering
  :config
  ;; Exclude no-littering files from 'recentf'
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  ;; Version backups
  (gsetq create-lockfiles nil           ; don't create lockfiles
         delete-old-versions t          ; don't ask before deleting old backups
         version-control t              ; use version control for backups
         kept-new-versions 10           ; keep 10 newest versions
         kept-old-versions 4            ; keep 4 oldest versions
         vc-make-backup-files)          ; backup files under vc too
  ;; Don't let customization use my init.el file
  (gsetq custom-file (no-littering-expand-etc-file-name "custom.el"))
  (general-add-hook 'after-init-hook
                    (lambda () (load custom-file 'noerror 'nomessage)))

  ;; Store auto-save files in `no-littering-var-directory'.
  (gsetq auto-save-file-name-transforms
         `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;;; Font & font sizing packages and settings

(set-face-attribute 'variable-pitch nil
                    :family "Fira Sans"
                    :height 140
                    :weight 'regular)

(use-package default-text-scale
  :general
  ("C--" #'default-text-scale-decrease
   "C-=" #'default-text-scale-increase
   "C-0" #'default-text-scale-reset)
  :init
  (general-unbind default-text-scale-mode-map
    "C-M--"
    "C-M-="
    "C-M-0")
  :config (default-text-scale-mode))

;; Toggle minor modes
(general-def
  :prefix-command 'ad:toggle
  :prefix-map 'ad:toggle-map
  "d" #'toggle-debug-on-error
  "o" #'dired-omit-mode
  "q" #'toggle-debug-on-quit
  "A" #'auto-fill-mode
  "t" #'toggle-truncate-lines)

(general-t "o" #'ad:toggle)

;;; Colors & Themes

;; Distinguish evil state by cursor shape/color
;; TODO advise `load-theme' to set cursor colors per theme
(gsetq evil-mode-line-format nil
       evil-normal-state-cursor '(box "#839496")
       evil-motion-state-cursor '(box "#b58900")
       evil-insert-state-cursor '(bar "#268bd2")
       evil-emacs-state-cursor  '(bar "#d33682")
       evil-visual-state-cursor '(box "#d33682"))

;; Disable old color theme when switching to new color theme
(defun ad:disable-themes (&rest _)
  "Disable all currently active color themes."
  (mapc #'disable-theme custom-enabled-themes))

(general-add-advice 'load-theme :before #'ad:disable-themes)

(use-package solarized-theme            ; I always come back to you
  :init
  ;; Basic settings - disprefer bold and italics, use high contrast
  (gsetq solarized-use-variable-pitch nil
         solarized-use-less-bold t
         solarized-use-more-italic nil
         solarized-distinct-doc-face t
         solarized-emphasize-indicators t
         solarized-high-contrast-mode-line nil)
  ;; Avoid all font size changes
  (gsetq solarized-height-minus-1 1.0
         solarized-height-plus-1 1.0
         solarized-height-plus-2 1.0
         solarized-height-plus-3 1.0
         solarized-height-plus-4 1.0)
  :config
  ;; Conditionally load the default theme based on whether we're
  ;; running the Emacs daemon.
  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (select-frame frame)
                  (load-theme 'solarized-dark t)))
    (load-theme 'solarized-dark t)))

(use-package doom-themes
  :defer t
  :init
  (gsetq doom-themes-enable-bold nil
         doom-themes-enable-italic t)
  :config
  ;; Correct org-mode's native fontification
  (doom-themes-org-config))

;; Mode line

(use-package moody
  :init
  ;; Advise `load-theme' to set mode-line face attributes correctly.
  (defun ad:set-mode-line-attributes (&rest _)
    "Unset the ':box' attribute for the `mode-line' face, and make ':overline'
and ':underline' the same value."
    (let ((line (face-attribute 'mode-line :underline)))
      (set-face-attribute 'mode-line          nil :overline  line)
      (set-face-attribute 'mode-line-inactive nil :overline  line)
      (set-face-attribute 'mode-line-inactive nil :underline line)
      (set-face-attribute 'mode-line          nil :box       nil)
      (set-face-attribute 'mode-line-inactive nil :box       nil)))

  (general-add-advice #'load-theme :after #'ad:set-mode-line-attributes)
  :config
  (gsetq x-underline-at-descent-line t
         moody-slant-function #'moody-slant-apple-rgb
         moody-mode-line-height 28)

  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))

(use-package minions
  :after moody
  :init
  (gsetq minions-mode-line-lighter "ʕ•ᴥ•ʔ"
         minions-mode-line-delimiters '("" . ""))
  :config (minions-mode))

;; File & directory handling

(use-package dired
  :general ('normal "-" #'counsel-dired-jump)
  :gfhook (nil #'auto-revert-mode)      ; automatically refresh
  :config
  ;; Basic settings
  (gsetq dired-auto-revert-buffer t
         dired-listing-switches "-lha --group-directories-first"
         dired-recursive-copies 'always
         dired-dwim-target t)

  (general-spc
    "d" #'dired-jump))

(general-with-package 'dired
  (put 'dired-find-alternate-file 'disabled nil)
  (general-def 'normal dired-mode-map
    ;; Navigation
    "h" #'dired-up-directory
    "j" #'dired-next-line
    "k" #'dired-previous-line
    "i" #'dired-find-alternate-file
    "f" #'counsel-find-file
    "F" #'find-name-dired
    ;; Misc
    "S" #'magit-status))

(use-package dired-x
  :after dired
  :ghook ('dired-mode-hook #'dired-omit-mode)
  :config (gsetq dired-omit-verbose nil))

;; (use-package all-the-icons-dired
;;   :ghook 'dired-mode-hook)

(use-package ignoramus
  :config
  ;; Ignore a few additional things
  (dolist (name '("company-statistics-cache.el"
                  ".metals"
                  ".bloop"))
    (add-to-list 'ignoramus-file-basename-exact-names name))

  (ignoramus-setup))

(use-package autorevert
  :init
  (gsetq auto-revert-verbose nil                ; autorevert quietly
         global-auto-revert-non-file-buffers t) ; and in dired, too

  ;; Notifications aren't used on OSX
  (when (eq system-type 'darwin)
    (gsetq auto-revert-use-notify nil))
  :config (global-auto-revert-mode))

;; Clean up whitespace on save
(general-add-hook 'before-save-hook #'whitespace-cleanup)

;;; Windows and buffers

(use-package ace-window
  :general (general-t "w" #'ace-window)
  :config
  ;; Basic settings
  (gsetq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
         aw-scope 'frame
         aw-dispatch-always t))

;; (use-package beacon
;;   :init
;;   ;; When to blink
;;   (gsetq beacon-blink-when-point-moves-vertically nil
;;          beacon-blink-when-point-moves-horizontally nil
;;          beacon-blink-when-window-scrolls nil
;;          beacon-blink-when-buffer-changes t
;;          beacon-blink-when-window-changes t
;;          beacon-blink-when-focused t)
;;   ;; How to blink
;;   (gsetq beacon-size 30
;;          beacon-color "#d33682")        ; Emacs/Visual state color
;;   :config
;;   ;; Not for terminal modes
;;   (add-to-list 'beacon-dont-blink-major-modes 'term-mode)
;;   (beacon-mode 1))

(defun ad:kill-this-buffer ()
  "Call `kill-this-buffer' without menu bar interaction."
  (interactive)
  (if (minibufferp)
      (abort-recursive-edit)
    (kill-buffer (current-buffer))))

(defun ad:kill-buffer-delete-window ()
  "Kill the current buffer and delete its window."
  (interactive)
  (ad:kill-this-buffer)
  (delete-window))

(defun ad:delete-other-windows ()
  "Make the current window the only one."
  (interactive)
  (if (eq (count-windows) 1)
      (winner-undo)
    (delete-other-windows)))

(defun ad:vsplit ()
  "Split the window vertically and switch to the new window."
  (interactive)
  (split-window-vertically)
  (other-window 1))

(defun ad:hsplit ()
  "Split the window horizontally and switch to the new window."
  (interactive)
  (split-window-horizontally)
  (other-window 1))

(general-t
  "f" #'toggle-frame-fullscreen
  "h" #'windmove-left
  "j" #'windmove-down
  "k" #'windmove-up
  "l" #'windmove-right
  "-" #'ad:vsplit
  "'" #'ad:hsplit
  "q" #'ad:kill-this-buffer
  "d" #'delete-window
  "D" #'ad:kill-buffer-delete-window
  "." #'ad:delete-other-windows
  "u" #'winner-undo
  "U" #'winner-redo)

;; (use-package shackle
;;   :init
;;   (gsetq shackle-rules
;;          '(
;;            ;; Org-mode buffers pop to the bottom
;;            ("\\*Org Src.*"       :regexp t :align below :size 0.20 :select t)
;;            ("CAPTURE\\-.*\\.org" :regexp t :align below :size 0.20 :select t)
;;            ("*Org Select*"                 :align below :size 0.20 :select t)
;;            (" *Org todo*"                  :align below :size 0.20 :select t)
;;            ;; Everything else pops to the top
;;            (magit-status-mode   :align above :size 0.33 :select t    :inhibit-window-quit t)
;;            (magit-log-mode      :align above :size 0.33 :select t    :inhibit-window-quit t)
;;            ("*Flycheck errors*" :align above :size 0.33 :select nil)
;;            ("*Help*"            :align above :size 0.33 :select t)
;;            ("*info*"            :align above :size 0.33 :select t)
;;            ("*lsp-help*"        :align above :size 0.33 :select nil)
;;            ("*xref*"            :align above :size 0.33 :select t)
;;            (compilation-mode    :align above :size 0.33 :select nil))
;;          shackle-default-rule '(:select t))
;;   :config (shackle-mode t))
(provide 'init)
;;; init.el ends here
