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

(defconst ad:is-a-mac-p (eq system-type 'darwin) "Are we on a mac?")

;; Preliminaries

(setq debug-on-error t)                 ; Enter debugger on error
(setq message-log-max 10000)            ; Keep more log messages

;; Set GC threshold as high as possible for fast startup
(setq gc-cons-threshold most-positive-fixnum)

;; Set GC threshold back to default value when idle
(run-with-idle-timer
 10 nil
 (lambda ()
   (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value)))
   (message "GC threshold restored to %S" gc-cons-threshold)))

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
  :init (gsetq evil-collection-company-use-tng nil)
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

(use-package which-key
  :init
  (gsetq which-key-idle-delay 0.4
         which-key-idle-secondary-delay 0.2
         which-key-sort-order 'which-key-prefix-then-key-order-reverse
         which-key-max-display-columns 6
         which-key-add-column-padding 2)
  :config
  ;; Set which-key replacements
  (gsetq which-key-replacement-alist '(((nil . "Prefix Command") . (nil . "prefix"))
                                       ((nil . "\\`\\?\\?\\'")   . (nil . "λ"))
                                       ((nil . "magit-")         . (nil . "git-"))))

  ;; Disable line numbers in which-key buffers
  (general-add-hook 'which-key-init-buffer-hook #'ad:disable-line-numbers-local)
  (which-key-mode))

(use-package with-editor
  :defer t
  :gfhook #'evil-insert-state
  :config
  (general-def 'normal with-editor-mode-map
    "RET" #'with-editor-finish
    "q" #'with-editor-cancel))

;; MacOS specific

(when ad:is-a-mac-p
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

;; Set up ligatures by way of `prettify-symbols-alist'
(defun ad:setup-ligatures ()
  "Append Iosevka ligatures to `prettify-symbols-alist'."
  (gsetq prettify-symbols-alist
         (append prettify-symbols-alist
                 '(
                   ;; Rightwards arrows
                   ("->"   . ?)
                   ("=>"   . ?)
                   ("->>"  . ?)
                   ("=>>"  . ?)
                   ("-->"  . ?)
                   ("==>"  . ?)
                   ("--->" . ?)
                   ("===>" . ?)
                   ("->-"  . ?)
                   ("=>="  . ?)
                   (">-"   . ?)
                   (">>-"  . ?)
                   (">>="  . ?)
                   ("~>"   . ?⤳)

                   ;; Leftwards arrows
                   ("<-"   . ?)
                   ("<<-"  . ?)
                   ("<<="  . ?)
                   ("<--"  . ?)
                   ("<=="  . ?)
                   ("<---" . ?)
                   ("<===" . ?)
                   ("-<-"  . ?)
                   ("=<="  . ?)
                   ("-<"   . ?)
                   ("=<"   . ?)
                   ("-<<"  . ?)
                   ("=<<"  . ?)

                   ;; Bidirectional arrows
                   ("<->"    . ?)
                   ("<=>"    . ?)
                   ("<-->"   . ?)
                   ("<==>"   . ?)
                   ("<--->"  . ?)
                   ("<===>"  . ?)
                   ("<---->" . ?)
                   ("<====>" . ?)

                   ;; Colons
                   ("::"  . ?)
                   (":::" . ?)

                   ;; Logical
                   ("/\\" . ?)
                   ("\\/" . ?)

                   ;; Comparison operators
                   (">="  . ?)
                   ("<="  . ?)

                   ;; Equality/inequality
                   ("=="    . ?)
                   ("!="    . ?)
                   ("==="   . ?)
                   ("!=="   . ?)
                   ("!=="   . ?)
                   ("=!="   . ?)        ; Cats uses a different sequence

                   ;; HTML comments
                   ("<!--"  . ?)
                   ("<!---" . ?)))))

(defun ad:refresh-prettify-symbols-mode ()
  "Toggle prettify symbols mode explicitly."
  (prettify-symbols-mode -1)
  (prettify-symbols-mode +1))

;; Hooks for modes in which to use ligatures
(mapc (lambda (hook)
        (general-add-hook hook (lambda ()
                                 (ad:setup-ligatures)
                                 (ad:refresh-prettify-symbols-mode))))
      '(text-mode-hook
        prog-mode-hook))

;; Enable `prettify-symbols-mode'
(global-prettify-symbols-mode +1)

;; Unprettify at right edge
(gsetq prettify-symbols-unprettify-at-point 'right-edge)

(use-package all-the-icons)
(use-package all-the-icons-dired
  :ghook 'dired-mode-hook)
(use-package all-the-icons-ivy
  :after ivy counsel counsel-projectile
  :config (all-the-icons-ivy-setup))

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
  (when ad:is-a-mac-p
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

(use-package windmove
  :config (gsetq windmove-wrap-around t))

(use-package winner
  :general
  (general-t
    "u" #'winner-undo
    "U" #'winner-redo)
  :config (winner-mode))

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
  "." #'ad:delete-other-windows)

(use-package shackle
  :init
  (gsetq shackle-rules
         '(
           ;; Org-mode buffers pop to the bottom
           ("\\*Org Src.*"       :regexp t :align below :size 0.20 :select t)
           ("CAPTURE\\-.*\\.org" :regexp t :align below :size 0.20 :select t)
           ("*Org Select*"                 :align below :size 0.20 :select t)
           (" *Org todo*"                  :align below :size 0.20 :select t)
           ;; Everything else pops to the top
           (magit-status-mode   :align above :size 0.33 :select t    :inhibit-window-quit t)
           (magit-log-mode      :align above :size 0.33 :select t    :inhibit-window-quit t)
           ("*Flycheck errors*" :align above :size 0.33 :select nil)
           ("*Help*"            :align above :size 0.33 :select t)
           ("*info*"            :align above :size 0.33 :select t)
           ("*lsp-help*"        :align above :size 0.33 :select nil)
           ("*xref*"            :align above :size 0.33 :select t)
           (compilation-mode    :align above :size 0.33 :select nil))
         shackle-default-rule '(:select t))
  :config (shackle-mode t))

(use-package beacon
  :init
  ;; When to blink
  (gsetq beacon-blink-when-point-moves-vertically nil
         beacon-blink-when-point-moves-horizontally nil
         beacon-blink-when-window-scrolls nil
         beacon-blink-when-buffer-changes t
         beacon-blink-when-window-changes t
         beacon-blink-when-focused t)
  ;; How to blink
  (gsetq beacon-size 30
         beacon-color "#d33682")        ; Emacs/Visual state color
  :config
  ;; Not for terminal modes
  (add-to-list 'beacon-dont-blink-major-modes 'term-mode)
  (beacon-mode 1))

;;; Org

(use-package org
  :general
  (general-spc
    "c" #'org-capture
    "a" #'org-agenda)
  :config
  ;; Set locations of org directory, agenda files, default notes file
  (defun ad:expand-org-file (file)
    (concat (file-name-as-directory org-directory) file))

  (gsetq org-directory (expand-file-name "~/org")
         org-default-notes-file (ad:expand-org-file "refile.org")
         org-archive-location (concat (ad:expand-org-file "archive.org") "::* From %s")
         org-agenda-files (mapcar #'ad:expand-org-file
                                  '("work.org"
                                    "home.org"
                                    "refile.org"
                                    "reminders.org"
                                    "emacs.org")))

  ;; Default settings
  (gsetq org-src-window-setup 'other-window
         org-src-fontify-natively t
         org-log-done 'time
         org-use-fast-todo-selection t
         org-startup-truncated nil
         org-tags-column -80
         org-enable-priority-commands nil
         org-reverse-note-order t)

  ;; Don't try to be intelligent about inserting blank lines
  (gsetq org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))

  ;; Re-define org-switch-to-buffer-other-window to NOT use org-no-popups.
  ;; Primarily for compatibility with shackle.
  ;; See: https://emacs.stackexchange.com/a/31634
  (defun org-switch-to-buffer-other-window (args)
    "Switch to buffer in a second window on the current frame.
In particular, do not allow pop-up frames. Returns the newly created buffer.
Redefined to allow pop-up windows."
    ;;  (org-no-popups
    ;;     (apply 'switch-to-buffer-other-window args)))
    (switch-to-buffer-other-window args))

  ;; Navigate by headings, using Ivy
  (gsetq org-goto-interface 'outline-path-completion
         org-outline-path-complete-in-steps nil)

  ;; Enable easy templates for src blocks
  (require 'org-tempo)

  ;; Enable habits
  (require 'org-habit)

  ;; TODO task states
  (gsetq org-todo-keywords
         '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
           (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "MEETING")))

  ;; Task state settings
  (gsetq org-enforce-todo-dependencies t
         org-enforce-todo-checkbox-dependencies t
         org-treat-S-cursor-todo-selection-as-state-change nil)

  ;; Tags based on state triggers; used for filtering tasks in agenda views
  ;;
  ;; Triggers break down into the following rules:
  ;;
  ;;   - moving a task to CANCELLED adds the CANCELLED tag
  ;;   - moving a task to WAITING adds the WAITING tag
  ;;   - moving a task to HOLD adds the WAITING and HOLD tags
  ;;   - moving a task to a done state removes the WAITING and HOLD tags
  ;;   - moving a task to TODO removes WAITING, CANCELLED, and HOLD tags
  ;;   - moving a task to NEXT removes WAITING, CANCELLED, and HOLD tags
  ;;   - moving a task to DONE removes WAITING, CANCELLED, and HOLD tags
  (gsetq org-todo-state-tags-triggers
         '(("CANCELLED" ("CANCELLED" . t))
           ("WAITING" ("WAITING" . t))
           ("HOLD" ("WAITING" . t) ("HOLD" . t))
           (done ("WAITING") ("HOLD"))
           ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
           ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
           ("DONE" ("WAITING") ("CANCELLED") ("HOLD"))))

  ;; Org capture templates
  (gsetq org-capture-templates
         '(("t" "TODO" entry (file+headline org-default-notes-file "Tasks")
            "* TODO %i%?" :empty-lines 1)
           ("s" "Scheduled" entry (file "~/org/reminders.org")
            "* TODO %i%?\n SCHEDULED:%^{Scheduled}T" :empty-lines 1)
           ("d" "Deadline" entry (file "~/org/reminders.org")
            "* TODO %i%?\n DEADLINE:%^{Deadline}t" :empty-lines 1)
           ("m" "Meeting" entry (file+headline org-default-notes-file "Meetings")
            "* MEETING %? :MEETING:\n %U" :empty-lines 1)))

  ;; Use sensible keybindings for capture buffers
  (general-def 'normal org-capture-mode-map
    "RET" #'org-capture-finalize
    "q" #'org-capture-kill
    "r" #'org-capture-refile)

  ;; Display the right `header-line-format' as well
  (general-add-hook
   'org-capture-mode-hook
   #'(lambda () (gsetq-local header-line-format
                        "Capture buffer. Finish 'RET', refile 'r', abort 'q'.")))

  ;; Refile targets include this file and any agenda file - up to 5 levels deep
  (gsetq org-refile-targets '((nil :maxlevel . 5)
                              (org-agenda-files :maxlevel . 5)))

  ;; Switch to insert state when capturing
  (general-add-hook 'org-capture-mode-hook #'evil-insert-state)
  (general-add-hook 'org-log-buffer-setup-hook #'evil-insert-state)

  ;; Include the filename in refile target paths; this allows refiling to the
  ;; top level of a target
  (gsetq org-refile-use-outline-path 'file)

  ;; Allow refiling to create parent tasks with confirmation
  (gsetq org-refile-allow-creating-parent-nodes 'confirm)

  ;; Do not use hierarchical steps in completion, since we use Ivy
  (gsetq org-outline-path-complete-in-steps nil)

  ;; Display agenda as the only window, but restore the previous configuration
  ;; afterwards; let's be polite.
  (gsetq org-agenda-window-setup 'only-window
         org-agenda-restore-windows-after-quit t)

  ;; Setting `org-agenda-tags-column' to 'auto' doesn't take line numbers into
  ;; account, so if you have line numbers enabled in an org agenda buffer, the
  ;; tags wrap and make things look very ugly.
  (general-add-hook 'org-agenda-mode-hook #'ad:disable-line-numbers-local)

  ;; Do not dim blocked tasks
  (gsetq org-agenda-dim-blocked-tasks nil)

  ;; Just use a newline to separate blocks
  (gsetq org-agenda-block-separator "")

  ;; Advise `org-agenda-quit' to save all existing org buffers, so things don't
  ;; get lost. Ask how I know.
  (general-add-advice 'org-agenda-quit :after #'org-save-all-org-buffers))

(use-package org-ql
  :after org)

;; Custom Org agenda building commands. This is listed separately for a couple
;; of reasons:
;;
;;   1. To break up a long ':config' section for org-mode
;;   2. To force loading of functions in 'org-ql-search.el'
;;
;; Startup time is not adversely impacted, since loading of 'org' + 'org-ql' is
;; deferred until eg. invoking `org-capture' or `org-agenda'. I'd love a better
;; solution here, but a working setup is .9 of the law.
(general-with-package 'org
  ;; Enable agenda building commands
  (require 'org-ql-search)

  ;; Test building an agenda
  (gsetq org-agenda-custom-commands
         '(("w" "Work Agenda"
            ((agenda)
             (org-ql-block '(and (todo "NEXT")
                                 (not (scheduled))
                                 (not (parent (todo "HOLD" "WAITING")))
                                 (tags "@work"))
                           ((org-ql-block-header "Next Tasks:")))
             (org-ql-block '(and (todo)
                                 (not (todo "HOLD" "WAITING"))
                                 (tags "@work")
                                 (or (children (todo))
                                     (children (done)))
                                 (not (children (todo "NEXT"))))
                           ((org-ql-block-header "Stuck Projects:")))
             (org-ql-block '(and (todo "WAITING")
                                 (not (scheduled))
                                 (tags "@work"))
                           ((org-ql-block-header "Waiting on:")))
             (org-ql-block '(and (todo)
                                 (not (scheduled))
                                 (not (todo "WAITING"))
                                 (tags "@work")
                                 (tags "charliework"))
                           ((org-ql-block-header "Charlie work:")))
             (org-ql-block '(and (todo)
                                 (tags "REFILE"))
                           ((org-ql-block-header "Refile:"))))))))

(use-package org-bullets
  :ghook 'org-mode-hook)

(use-package evil-org
  :after evil org
  :ghook 'org-mode-hook
  :gfhook #'(lambda () (evil-org-set-key-theme))
  :config
  ;; Evil bindings in org agenda
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;;; Version control

(use-package magit
  :defer t
  :general
  ('normal "S" #'magit-status)
  (general-t
    "g"  #'(:ignore t :which-key "Git")
    "gs" #'magit-status
    "gl" #'magit-log-all
    "gL" #'magit-log-buffer-file
    "gc" #'magit-commit
    "gp" #'magit-push
    "gf" #'magit-pull
    "gb" #'magit-blame)
  :config
  ;; Basic settings
  (gsetq magit-save-repository-buffers 'dontask
         magit-refs-show-commit-count 'all
         magit-branch-prefer-remote-upstream '("master")
         magit-branch-adjust-remote-upstream-alist '(("origin/master" "master"))
         magit-revision-show-gravatars nil)

  ;; Show fine-grained diffs in hunks
  (gsetq-default magit-diff-refine-hunk t)

  ;; Set Magit's repository directories for `magit-list-repositories', based on
  ;; Projectile's known projects. This also has effects on `magit-status' in
  ;; "potentially surprising ways". Initialize after Projectile loads, and every
  ;; time we switch projects (we may switch to a previously unknown project).
  (defun ad:set-magit-repository-directories-from-projectile-known-projects ()
    "Set `magit-repository-directories' from known Projectile projects."
    (let ((project-dirs (bound-and-true-p projectile-known-projects)))
      (setq magit-repository-directories
            ;; Strip trailing slashes from project-dirs, since Magit adds them
            ;; again. Double trailing slashes break presentation in Magit
            (mapcar #'directory-file-name project-dirs))))

  (with-eval-after-load 'projectile
    (ad:set-magit-repository-directories-from-projectile-known-projects))

  (general-add-hook 'projectile-switch-project-hook
                    #'ad:set-magit-repository-directories-from-projectile-known-projects)

  ;; Disable auto-fill-mode in git commit buffers
  (general-remove-hook 'git-commit-setup-hook
                       #'git-commit-turn-on-auto-fill))

(use-package evil-magit
  :after evil magit)

(use-package git-timemachine
  :general (general-t "gt" #'git-timemachine))

;;; Completion and search

(use-package flx)                       ; used by ivy
(use-package smex)                      ; used by counsel

(use-package ivy
  :demand t
  :general (general-spc "f" #'ivy-switch-buffer)
  :config
  ;; Basic settings
  (gsetq ivy-use-virtual-buffers t
         ivy-initial-inputs-alist nil
         ivy-count-format "")

  ;; Enable fuzzy searching everywhere*
  ;;
  ;; *not everywhere
  (gsetq ivy-re-builders-alist
         '((swiper            . ivy--regex-plus)    ; convert spaces to '.*' for swiper
           (ivy-switch-buffer . ivy--regex-plus)    ; and buffer switching
           (counsel-rg        . ivy--regex-plus)    ; and ripgrep
           (t                 . ivy--regex-fuzzy))) ; go fuzzy everywhere else

  ;; Keybindings
  (general-def ivy-minibuffer-map
    "<escape>" #'minibuffer-keyboard-quit ; the natural choice
    "<next>" #'ivy-scroll-up-command      ; default, here for documentation
    "<prior>" #'ivy-scroll-down-command   ; same here
    "C-j" #'ivy-next-history-element      ; repeat command with next element
    "C-k" #'ivy-previous-history-element  ; repeat command with prev element
    "C-'" #'ivy-avy)                      ; pick a candidate using avy

  ;; Swap "?" for 'ivy-resume'
  (general-def 'normal "?" #'ivy-resume)
  (general-r "?" #'evil-search-backward)

  (ivy-mode 1))

(use-package counsel
  :demand t
  :general
  ;; Replace standard 'evil-ex-search-forward' with swiper
  ('normal "/" #'counsel-grep-or-swiper)
  ;; Remap standard commands to their counsel analogs
  (general-def
    [remap execute-extended-command] #'counsel-M-x
    [remap find-file]                #'counsel-find-file
    [remap describe-bindings]        #'counsel-descbinds
    [remap describe-face]            #'counsel-describe-face
    [remap describe-function]        #'counsel-describe-function
    [remap describe-variable]        #'counsel-describe-variable
    [remap info-lookup-symbol]       #'counsel-info-lookup-symbol
    [remap completion-at-point]      #'counsel-company
    [remap org-goto]                 #'counsel-org-goto)
  ;; Goto org headings
  (general-m org-mode-map
    "j" #'counsel-org-goto)
  ;; For, eg. switching to a newly created project
  (general-spc "F" #'counsel-find-file)
  ;; Load themes
  (general-t
    "t" #'counsel-load-theme)
  :config (counsel-mode 1))

(use-package swiper
  :demand t
  :general ([remap isearch-forward] #'swiper)
  :init (gsetq swiper-goto-start-of-match t))

(use-package avy
  :general (general-spc "s" #'avy-goto-char-timer)
  :init (gsetq avy-all-windows nil
               avy-timeout-seconds 0.25))

;; TODO debug wrong type argument error when using ivy-avy immediately after
;; starting Emacs and choosing a file from projectile's known files
(use-package ivy-avy
  :after ivy avy)

(use-package prescient
  :config (prescient-persist-mode))

(use-package ivy-prescient
  :after ivy
  :demand t
  :config (ivy-prescient-mode))

(use-package ivy-rich
  :after ivy counsel
  :init
  ;; Align virtual buffers, and abbreviate paths
  (gsetq ivy-virtual-abbreviate 'full
         ivy-rich-path-style 'abbrev
         ivy-rich-switch-buffer-align-virtual-buffer t)
  :config (ivy-rich-mode 1))

(use-package yasnippet
  :defer t
  :general
  (general-def help-map
    "y" #'yas-describe-tables)
  :ghook ('prog-mode-hook #'yas-minor-mode)
  :config
  ;; Never expand snippets in normal state
  (general-def 'normal yas-minor-mode-map
    [remap yas-expand] #'ignore)

  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

;;; Project management

(use-package projectile
  :general
  (general-spc
    "P" #'projectile-find-file-in-known-projects
    "r" #'projectile-switch-project
    "v" #'projectile-invalidate-cache
    "D" #'projectile-dired)
  :config
  ;; Basic settings
  (gsetq projectile-enable-caching t
         projectile-find-dir-includes-top-level t
         projectile-switch-project-action #'projectile-dired
         projectile-indexing-method 'alien
         projectile-completion-system 'ivy)

  ;; Cleanup dead projects when idle
  (run-with-idle-timer 10 nil #'projectile-cleanup-known-projects)

  (projectile-mode))

;; Advise some functions to additionally trigger `projectile-invalidate-cache'.
;; This is useful for magit branching commands as well as moving files in dired.
(general-with-package 'projectile
  (defun ad:projectile-invalidate-cache (&rest _args)
    "Runs `projectile-invalidate-cache'."
    (projectile-invalidate-cache nil))

  (general-add-advice '(magit-checkout
                        magit-branch-and-checkout
                        dired-do-rename
                        dired-do-rename-regexp)
                      :after #'ad:projectile-invalidate-cache))

(use-package counsel-projectile
  :general
  (general-spc
    "/" #'ad:counsel-projectile-rg
    "p" #'counsel-projectile-find-file)
  :config
  (gsetq counsel-projectile-sort-files t)

  ;; Make 'counsel-projectile-rg' work outside projects
  (defun ad:counsel-projectile-rg ()
    "Call `counsel-projectile-rg' if in a project, and `counsel-rg' otherwise."
    (interactive)
    (if (projectile-project-p)
        (counsel-projectile-rg)
      (counsel-rg)))

  (counsel-projectile-mode))

;; General programming

(use-package electric
  :init
  ;; Disable pairing in minibuffer
  (gsetq electric-pair-inhibit-predicate #'(lambda (_) (minibufferp)))
  :config (electric-pair-mode))

(use-package paren
  :config (show-paren-mode))

(use-package evil-surround
  :init
  ;; Swap the default bindings for padded/non-padded delimiters
  (gsetq evil-surround-pairs-alist
         '(
           ;; Left pair triggers no-spaces version
           (?\( . ("(" . ")"))
           (?\[ . ("[" . "]"))
           (?\{ . ("{" . "}"))
           ;; Right pair triggers padded version
           (?\) . ("( " . " )"))
           (?\] . ("[ " . " ]"))
           (?\} . ("{ " . " }"))
           ;; Everything else
           (?# . ("#{" . "}"))
           (?b . ("(" . ")"))
           (?B . ("{" . "}"))
           (?> . ("<" . ">"))
           (?t . evil-surround-read-tag)
           (?< . evil-surround-read-tag)
           (?f . evil-surround-function)))
  :config (global-evil-surround-mode))

(use-package rainbow-delimiters
  :ghook 'prog-mode-hook 'text-mode-hook)

(use-package rainbow-mode
  :ghook 'prog-mode-hook)

(use-package company
  :config
  ;; Basic settings
  (gsetq company-idle-delay 0.2
         company-minimum-prefix-length 2
         company-tooltip-align-annotations t
         company-show-numbers t)

  ;; Complete, using the current selection
  (general-def company-active-map
    "C-;" #'company-complete-selection)

  ;; Add YASnippet support for all company backends
  ;; See: https://github.com/syl20bnr/spacemacs/pull/179
  (defun ad:company-backend-with-yas (backends)
    (if (and (listp backends) (memq 'company-yasnippet backends))
        backends
      (append (if (consp backends)
                  backends
                (list backends))
              '(:with company-yasnippet))))

  ;; Add YASnippet to all backends
  (gsetq company-backends
         (mapcar #'ad:company-backend-with-yas company-backends))

  (global-company-mode))

;; Use prescient instead of company-statistics for smrts
(use-package company-prescient
  :after company
  :config (company-prescient-mode))

(use-package company-emoji
  :after company
  :if (version< "27.0" emacs-version)
  :config
  ;; Adjust the font settings for the frame
  (defun ad:set-emoji-font (frame)
    "Adjust the font settings of FRAME so Emacs can display emoji properly."
    (if ad:is-a-mac-p
        ;; For MacOS
        (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") frame 'prepend)
      ;; For Linux/GNU
      (set-fontset-font t 'symbol (font-spec :family "Symbola") frame 'prepend)))

  (general-add-hook 'after-make-frame-functions #'ad:set-emoji-font)
  ;; Add emjoi completion backend
  (add-to-list 'company-backends 'company-emoji))

(use-package flycheck
  :ghook ('after-init-hook #'global-flycheck-mode)
  :config
  ;; Basic settings
  (gsetq flycheck-display-errors-delay 0.4)

  ;; Remove background colors for fringe indicators
  (custom-set-faces
   '(flycheck-fringe-error ((t :background nil)))
   '(flycheck-fringe-warning ((t :background nil)))
   '(flycheck-fringe-info ((t :background nil))))

  ;; Get me outta here
  (general-def 'normal flycheck-error-list-mode
    "q" #'quit-window))

(general-with-package 'prog-mode
  (general-m prog-mode-map
    "j" #'flycheck-next-error
    "k" #'flycheck-previous-error
    "E" #'flycheck-list-errors))

(use-package lsp-mode
  :init
  ;; Performance tuning per: https://emacs-lsp.github.io/lsp-mode/page/performance/
  (gsetq lsp-idle-delay 0.5
         lsp-completion-provider :capf
         read-process-output-max (* 1024 1024))

  ;; Disable the following settings that lead to 'void-function' warnings during LSP startup;
  (gsetq lsp-enable-dap-auto-configure nil
         lsp-modeline-diagnostics-enable nil
         lsp-modeline-code-actions-enable nil)
  :config
  (general-def 'normal lsp-mode-map
    "N" #'lsp-describe-thing-at-point
    "RET" #'lsp-find-definition)

  (gsetq lsp-keymap-prefix "mm")
  (general-add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)

  (general-m lsp-mode-map
    "m" lsp-command-map
    "i" #'lsp-goto-implementation
    "D" #'lsp-find-declaration
    "x" #'lsp-find-references
    "r" #'lsp-rename
    "R" #'lsp-workspace-restart
    "=" #'lsp-format-buffer
    "l" #'lsp-workspace-show-log))

(use-package lsp-metals
  :init (gsetq lsp-metals-server-command "metals-emacs"))

(use-package lsp-ui
  :ghook ('lsp-mode-hook #'lsp-ui-mode)
  :commands lsp-ui-mode
  ;; :init (general-add-hook 'lsp-ui-doc-frame-hook)
  )

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package term
  :init
  ;; Disable line numbers and current line highlighting in terminal buffers
  (general-add-hook 'term-mode-hook
                    #'(lambda ()
                        (ad:disable-line-numbers-local)
                        (gsetq-local global-hl-line-mode nil))))

(use-package vterm
  :init
  (gsetq vterm-kill-buffer-on-exit t
         vterm-max-scrollback 10000))

(use-package shell-pop
  :general (general-m "t" #'shell-pop)
  :init (gsetq shell-pop-window-size 40
               shell-pop-window-position 'top
               shell-pop-full-span t)
  :config
  ;; Set shell type to term
  (gsetq shell-pop-shell-type
         '("vterm" "vterm" #'(lambda () (vterm)))))

;; Git specific modes

(use-package git-commit
  :defer t
  :init
  (gsetq
   git-commit-usage-message
   "Type 'RET' to finish, 'q' to cancel, and \\[git-commit-prev-message] and \\[git-commit-next-message] to recover older messages")
  :config
  ;; Remove style conventions
  (general-remove-hook 'git-commit-finish-query-functions
                       #'git-commit-check-style-conventions))

(use-package gitconfig-mode
  :defer t)

(use-package gitignore-mode
  :defer t)

(use-package gitattributes-mode
  :defer t)

;; Lisp/Emacs Lisp

(use-package elisp-mode
  :general
  (general-m emacs-lisp-mode-map
    "b" #'eval-buffer
    "r" #'eval-region
    "f" #'eval-defun)

  (general-def 'normal emacs-lisp-mode-map
    "RET" #'xref-find-definitions
    "<S-return>" #'pop-tag-mark)
  :config
  (gsetq emacs-lisp-docstring-fill-column 80))

;; Markdown

(use-package vmd-mode
  :defer t)

(use-package markdown-mode
  :general
  (general-m markdown-mode-map
    "p" #'vmd-mode))

;; Scala

(use-package scala-mode
  :mode ("\\.scala\\'" "\\.sbt\\'" "\\.worksheet\\.sc\\'")
  :gfhook #'lsp-deferred
  :general
  (general-m scala-mode-map
    "b" #'lsp-metals-build-import
    "c" #'lsp-metals-build-connect
    "d" #'lsp-metals-doctor-run)
  :config
  ;; Indentation preferences
  (gsetq scala-indent:default-run-on-strategy
         scala-indent:operator-strategy
         scala-indent:use-javadoc-style t)

  ;; Insert newline in a multiline comment should insert an asterisk
  (defun ad|scala-mode-newline-comments ()
    "Insert a leading asterisk in multiline comments, when hitting 'RET'."
    (interactive)
    (newline-and-indent)
    (scala-indent:insert-asterisk-on-multiline-comment))
  (define-key scala-mode-map (kbd "RET") #'ad|scala-mode-newline-comments))

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

;; Python

(use-package lsp-python-ms
  :init (gsetq lsp-python-ms-auto-install-server t)
  :ghook ('python-mode-hook #'(lambda ()
                                (require 'lsp-python-ms)
                                (lsp-deferred))))

(use-package conda
  :defer t
  :init
  (gsetq conda-anaconda-home (expand-file-name "~/miniconda3")
         conda-env-home-directory (expand-file-name "~/miniconda3")))

;; YAML

(use-package yaml-mode
  :mode ("\\.yaml\\'" "\\.yml\\'" "MLproject\\'"))

;; Nix

(use-package nix-mode
  :mode "\\.nix\\'")

(provide 'init)
;;; init.el ends here
