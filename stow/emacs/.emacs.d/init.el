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

;;; Constants

(defconst is-a-mac-p (eq system-type 'darwin) "Are we on MacOS?")

(defconst minibuffer-maps
  '(minibuffer-local-map
    minibuffer-local-ns-map
    minibuffer-local-completion-map
    minibuffer-local-must-match-map
    minibuffer-local-isearch-map
    evil-ex-completion-map)
  "List of minibuffer keymaps.")

;;; Functions

(defun ad:disable-line-numbers ()
  "Unequivocally disable line numbers."
  (display-line-numbers-mode -1))

(defun ad:relative-line-numbers ()
  "Toggle relative line numbers."
  (when (bound-and-true-p display-line-numbers-mode)
    (setq-local display-line-numbers 'visual)))

(defun ad:absolute-line-numbers ()
  "Toggle absolute line numbers."
  (when (bound-and-true-p display-line-numbers-mode)
    (setq-local display-line-numbers 'absolute)))

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

;;; Preliminaries

(setq debug-on-error t)                 ; Enter debugger on error
(setq message-log-max 10000)            ; Keep more log messages

;;; Startup tuning

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

;;; Package initialization

(require 'package)
(package-initialize 'noactivate)
(eval-when-compile
  (require 'use-package))

;;; General

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

;;; Evil & Evil Collection

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

;;; MacOS

(use-package exec-path-from-shell
  :if is-a-mac-p
  :init (gsetq exec-path-from-shell-check-startup-files nil)
  :config (exec-path-from-shell-initialize))

(use-package osx-trash
  :if is-a-mac-p
  :config (osx-trash-setup))

(when is-a-mac-p
  (gsetq mac-command-modifier 'meta	; command is meta
     mac-option-modifier 'super	; alt/option is super
     mac-function-modifier 'none))	; reserve 'function' for macOS

;;; Emacs Defaults

(gsetq-default blink-cursor-mode -1                  ; no blinking
               ring-bell-function #'ignore           ; no ringing
               inhibit-startup-screen t              ; no startup screen
               initial-scratch-message ""            ; no scratch message
               cursor-in-non-selected-windows nil    ; cursors only in selected windows
               delete-by-moving-to-trash t           ; delete to trash
               fill-column 100                       ; set fill column for modern displays
               help-window-select t                  ; focus new help windows
               indent-tabs-mode nil                  ; don't use tabs
               tab-width 4                           ; but set their width anyway
               left-margin-width 0                   ; no left margins
               right-margin-width 0                  ; no right margins
               recenter-positions '(0.33 top bottom) ; recentering positions
               sentence-end-double-space nil         ; single space after sentences
               require-final-newline t               ; require final newline
               show-trailing-whitespace nil          ; don't show trailing whitespace
               uniquify-buffer-name-style 'forward   ; uniquify buffer names
               window-combination-resize t           ; resize windows proportionally
               frame-resize-pixelwise t              ; resize frames by pixel
               history-length 1000                   ; more history
               use-dialog-box nil)                   ; don't use dialogs for mouse input

(fset 'yes-or-no-p 'y-or-n-p)                        ; replace yes/no prompts with y/n
(fset 'display-startup-echo-area-message #'ignore)   ; no startup message in the minibuffer
(delete-selection-mode 1)                            ; replace region when inserting text
(put 'downcase-region 'disabled nil)                 ; enable `downcase-region'
(put 'upcase-region 'disabled nil)                   ; enable `upcase-region'
(global-hl-line-mode)                                ; highlight the current line
(line-number-mode)                                   ; display line number in modeline
(column-number-mode)                                 ; display column number in modeline

;;; Line numbers

;; Use Vim-style visual line numbers, with an absolute line number for the current line
(gsetq-default display-line-numbers 'visual
               display-line-numbers-widen t
               display-line-numbers-current-absolute t)

;; Switch to absolute line numbers in 'insert' state
(general-add-hook 'evil-insert-state-entry-hook #'ad:absolute-line-numbers)
(general-add-hook 'evil-insert-state-exit-hook #'ad:relative-line-numbers)

;; Bedazzle the current line number for kicks
(custom-set-faces
 '(line-number-current-line ((t :inherit warning))))

;; Toggle various modes
(general-def
  :prefix-command 'ad:toggle
  :prefix-map 'ad:toggle-map
  "d" #'toggle-debug-on-error
  "o" #'dired-omit-mode
  "q" #'toggle-debug-on-quit
  "A" #'auto-fill-mode
  "t" #'toggle-truncate-lines)

(general-t "o" #'ad:toggle)

;;; Fonts and font sizing

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

;; Default variable pitch font
(set-face-attribute 'variable-pitch nil
                    :family "Helvetica Neue"
                    :height 140
                    :weight 'regular)

;; For icons used in various places
(use-package all-the-icons)

;;; Emacs file management

(use-package no-littering
  :demand t
  :config
  ;; Exclude no-littering files from 'recentf'
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)

  ;; Version backups
  (gsetq create-lockfiles nil           ; no lockfiles
         delete-old-versions t          ; don't ask before deleting old backups
         version-control t              ; use version control
         kept-new-versions 10           ; keep the 10 newest
         kept-old-versions 4            ; and the 4 oldest
         vc-make-backup-files)          ; backup files under vc, too

  ;; Don't let customizations use my init.el file
  (gsetq custom-file (no-littering-expand-etc-file-name "custom.el"))
  (general-add-hook 'after-init-hook
                    (lambda () (load custom-file 'noerror 'nomessage)))

  ;; Store auto-save files in `no-littering-var-directory'
  (gsetq auto-save-file-name-transforms
         `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;;; Color themes

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
  :init
  (gsetq doom-themes-enable-bold nil
         doom-themes-enable-italic nil)
  :config
  (require 'doom-themes-ext-org)
  (doom-themes-org-config))

;;; Modeline

(use-package doom-modeline
  :init
  (gsetq doom-modeline-height 30
         doom-modeline-icon t
         doom-modeline-minor-modes t)
  :config (doom-modeline-mode))

(use-package minions
  :demand t
  :after doom-modeline
  :init
  ;; (gsetq minions-mode-line-lighter "ʕ•ᴥ•ʔ"
  ;;        minions-mode-line-delimiters '("" . ""))
  :config (minions-mode))

;;; Directory handling

(use-package dired
  :general ('normal "-" #'counsel-dired-jump)
  :gfhook (nil #'auto-revert-mode)
  :config
  ;; Basic preferences
  (gsetq dired-auto-revert-buffer t
         dired-listing-switches "-lha --group-directories-first" ; assumes GNU 'ls'
         dired-recursive-copies 'always
         dired-dwim-target t)

  (general-spc
    "d" #'dired-jump
    "D" #'dired-jump-other-window))

(use-package dired-x
  :after dired
  :ghook ('dired-mode-hook #'dired-omit-mode)
  :config (gsetq dired-omit-verbose nil))

(general-with-package 'dired
                       (put 'dired-find-alternate-file 'disabled nil)
                       (general-def 'normal dired-mode-map
                         ;; navigation
                         "h" #'dired-up-directory
                         "j" #'dired-next-line
                         "k" #'dired-previous-line
                         ;; magit
                         "S" #'magit-status))

(use-package all-the-icons-dired
  :ghook 'dired-mode-hook)

;;; Ignore settings

(use-package ignoramus
  :config
  (dolist (name '("company-statistics-cache.el"
                  ".metals"
                  ".bloop"))
    (add-to-list 'ignoramus-file-basename-exact-names name))

  (ignoramus-setup))

;;; File handling

(use-package autorevert
  :init
  (gsetq auto-revert-verbose nil
         global-auto-revert-non-file-buffers t)

  ;; MacOS doesn't use notifications
  (when is-a-mac-p (gsetq auto-revert-use-notify nil))
  :ghook ('after-init-hook #'global-auto-revert-mode))

;; Clean up whitespace on file save
(general-add-hook 'before-save-hook #'whitespace-cleanup)

;;; Window/buffer management

(use-package ace-window
  :general (general-t "w" #'ace-window)
  :config
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

;; Bedazzle the window I just focused, pleaase
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

;;; Which-key

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

;;; Completion and Search

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

  ;; Advise `ivy-resume' to destroy highlighting after completion. See also `swiper'
  (general-add-advice 'ivy-resume :after #'(lambda (&rest _)
                                             (evil-ex-nohighlight)))
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
    "j" #'counsel-org-goto
    "<" #'org-insert-structure-template)
  ;; For, eg. switching to a newly created project
  (general-spc
    "w" #'write-file
    "F" #'counsel-find-file)
  ;; Load themes
  (general-t
    "T" #'counsel-load-theme)
  :config (counsel-mode 1))

(use-package swiper
  :demand t
  :general ([remap isearch-forward] #'swiper)
  :init (gsetq swiper-goto-start-of-match t)
  :config
  ;; Advise swiper to destroy highlighting after search. Use 'evil-ex-search-forward' for more fine
  ;; grained control of persistent highlighting.
  (general-add-advice 'swiper :after #'(lambda (&rest _)
                                         (evil-ex-nohighlight))))

(use-package avy
  :general (general-spc "s" #'avy-goto-char-timer)
  :init (gsetq avy-all-windows nil
               avy-timeout-seconds 0.25))

;; TODO debug wrong type argument error when using ivy-avy immediately after
;; starting Emacs and choosing a file from projectile's known files
(use-package ivy-avy :commands ivy-avy)

(use-package prescient
  :config (prescient-persist-mode))

(use-package ivy-prescient
  :after counsel
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

(use-package all-the-icons-ivy
  :after counsel-projectile
  :config (all-the-icons-ivy-setup))

(use-package company
  :init
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 1
        company-tooltip-limit 12
        company-show-numbers t
        company-tooltip-align-annotations t)
  :hook (after-init . global-company-mode)
  :config
  ;; Update a company backend with yasnippet; see https://github.com/syl20bnr/spacemacs/pull/179
  (defun ad:company-backend-with-yasnippet (backends)
    "Adds YASnippet support to existing company backends."
    (if (and (listp backends) (memq 'company-yasnippet backends))
        backends
      (append (if (consp backends)
                  backends
                (list backends))
              '(:with company-yasnippet))))

  ;; Add YASnippet support to company backends
  (gsetq company-backends
         (mapcar #'ad:company-backend-with-yasnippet company-backends)))

(use-package company-prescient
  :after company
  :config (company-prescient-mode))

(use-package company-emoji
  :after company
  :if (version<= "27.0" emacs-version)
  :config
  ;; Adjust the font settings for the frame
  (defun ad:set-emoji-font (frame)
    "Adjust the font settings of FRAME so Emacs can display emoji properly."
    (if is-a-mac-p
        ;; for macOS
        (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") frame 'prepend)
      ;; for GNU/Linux
      (set-fontset-font t 'symbol (font-spec :family "Symbola") frame 'prepend)))

  (general-add-hook 'after-make-frame-functions #'ad:set-emoji-font)
  ;; Add emoji completion backend to company
  (add-to-list 'company-backends 'company-emoji))

(use-package yasnippet
  :defer t
  :general
  (general-def help-map
    "y" #'yas-describe-tables)
  :ghook ('prog-mode-hook #'yas-minor-mode)
  :config
  ;; Never expand snippets in normal mode
  (general-def 'normal yas-minor-mode-map
    [remap yas-expand] #'ignore)

  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

;;; Org

(use-package org
  :defer t
  :general
  ;; Available anywhere commands
  (general-spc
    "c" #'org-capture
    "a" #'org-agenda)
  (general-m 'normal org-mode-map
    "l" #'org-insert-link
    "t" #'org-todo)
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
  (general-add-hook 'org-agenda-mode-hook #'ad:disable-line-numbers)

  ;; Do not dim blocked tasks
  (gsetq org-agenda-dim-blocked-tasks nil)

  ;; Just use a newline to separate blocks
  (gsetq org-agenda-block-separator "")

  ;; Advise `org-agenda-quit' to save all existing org buffers, so things don't
  ;; get lost. Ask how I know.
  (general-add-advice 'org-agenda-quit :after #'org-save-all-org-buffers))

(use-package org-ql
  :after org)

(use-package org-bullets
  :ghook 'org-mode-hook)

(use-package evil-org
  :after evil org
  :ghook 'org-mode-hook
  :gfhook #'(lambda () (evil-org-set-key-theme))
  :config
  ;; Evil bindings for agenda views, too
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

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

;;; Terminal

(use-package term
  :gfhook #'(lambda ()
              (ad:disable-line-numbers)
              (global-hl-line-mode -1)))

(use-package vterm
  :commands vterm
  :init
  (gsetq vterm-kill-buffer-on-exit t
         vterm-max-scrollback 10000)

  (general-add-hook 'vterm-mode-hook #'(lambda ()
                                         (ad:disable-line-numbers)
                                         (global-hl-line-mode -1))))

(use-package shell-pop
  :general (general-t "t" #'shell-pop)
  :init
  (gsetq shell-pop-window-size 40
         shell-pop-window-position 'top
         shell-pop-full-span t)
  :config
  ;; Set shell type to term
  (gsetq shell-pop-shell-type '("vterm" "vterm" #'(lambda () (vterm)))))

;;; LSP

(use-package lsp-mode
  :hook ((scala-mode  . lsp-deferred)
         (python-mode . (lambda () (require 'lsp-python-ms)(lsp-deferred)))
         (lsp-mode    . lsp-enable-which-key-integration))
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
  ;; TODO debug why these don't appear for minutes if 'lsp-mode-map' is specified
  (general-def 'normal
    "N" #'lsp-describe-thing-at-point
    "RET" #'lsp-find-definition
    "<S-return>" #'pop-tag-mark)

  ;; TODO debug why these don't appear for minutes if 'lsp-mode-map' is specified
  (general-m
    "m" lsp-command-map
    "R" #'lsp-restart-workspace
    "Q" #'lsp-workspace-shutdown
    "s" #'lsp-describe-session
    "l" #'lsp-workspace-show-log)

  ;; Bind LSP command map to our major mode leader
  (gsetq lsp-keymap-prefix "mm")
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

(use-package lsp-ui
  :commands lsp-ui-mode
  :gfhook ('lsp-ui-doc-frame-mode-hook #'ad:disable-line-numbers)
  :init (gsetq lsp-ui-sideline-enable nil)
  :config
  ;; Style settings for LSP doc UI
  (gsetq lsp-ui-doc-enable t
     lsp-ui-doc-position 'top
     lsp-ui-doc-max-width 160
     lsp-ui-doc-max-height 40
     lsp-ui-doc-use-webkit nil))

(use-package lsp-ivy
  :after lsp-mode
  :commands lsp-ivy-workplace-symbol)

;;; Version control

(use-package magit
  :commands magit-status
  :general ('normal "S" #'magit-status)
  (general-t
    "g" #'(:ignore t :which-key "Git")
    "gs" #'magit-status
    "gl" #'magit-log-all
    "gL" #'magit-log-bufer-file
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

(use-package with-editor
  :defer t
  :gfhook #'evil-insert-state
  :config
  (general-def 'normal with-editor-mode-map
    "RET" #'with-editor-finish
    "q" #'with-editor-cancel))

;;; Project management lol

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
  :after counsel
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

;;; General programming

(use-package electric
  :init
  ;; Disable pairing in minibuffers
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

;;; Git flavored modes

(use-package git-commit
  :defer t
  :init
  (gsetq git-commit-usage-message
         "Type 'RET' to finish, 'q' to cancel, and \\[git-commit-prev-message] and \\[git-commit-next-message] to recover older messages.")
  :config
  ;; Remove style conventions
  (general-remove-hook 'git-commit-finish-query-functions #'git-commit-check-style-conventions))

(use-package gitconfig-mode :defer t)
(use-package gitignore-mode :defer t)
(use-package gitattributes_mode :defer t)

;;; Markdown

(use-package vmd-mode
  :commands vmd-mode)

(use-package markdown-mode
  :mode ("\\.md\\'" "\\.markdown\\'")
  :general (general-m markdown-mode-map
             "p" #'vmd-mode))

;;; Emacs Lisp

(use-package elisp-mode
  :general
  (general-m emacs-lisp-mode-map
    "b" #'eval-buffer
    "r" #'eval-region
    "f" #'eval-defun)

  (general-def 'normal emacs-lisp-mode-map
    "RET" #'xref-find-definitions
    "<S-return>" #'pop-tag-mark)
  :init
  (gsetq emacs-lisp-docstring-fill-column 100))

;;; Scala

(use-package scala-mode
  :mode ("\\.scala\\'" "\\.sbt\\'")
  :general
  ;; Bind available 'lsp-metals' actions
  (general-m scala-mode-map
    ;; LSP metals session functionality
    "i" #'lsp-metals-build-import
    "c" #'lsp-metals-build-connect
    "D" #'lsp-metals-doctor-run
    ;; Supported LSP actions
    "g" #'lsp-find-definition
    "x" #'lsp-find-references
    "r" #'lsp-rename
    "=" #'lsp-format-buffer)
  :config
  ;; Indentation preferences
  (gsetq scala-indent:default-run-on-strategy
     scala-indent:operator-strategy
     scala-indent:use-javadoc-style t)

  ;; Inserting newline in a multiline comment should do what I mean
  (defun ad:scala-mode-newline-in-multiline-comment ()
    "Insert a leading asterisk in Scala multiline comments, when hitting 'RET'."
    (interactive)
    (newline-and-indent)
    (scala-indent:insert-asterisk-on-multiline-comment))

  (general-def 'insert scala-mode-map
    "RET" #'ad:scala-mode-newline-in-multiline-comment))

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

;;; Nix

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package nix-shell
  :ensure nil
  :commands nix-shell nix-unpack)

(use-package nix-drv-mode
  :ensure nil
  :mode "\\.drv\\'")

;;; Python

(use-package lsp-python-ms
  ;; TODO don't auto-install server once you can build it via Nix
  :init (gsetq lsp-python-ms-auto-install-server t))

(use-package conda
  :defer t
  :init
  ;; WARNING: do NOT set `conda-anaconda-home' instead, as it breaks automatic discovery and use of
  ;; Conda environments. It's annoyingly brittle, but using the appropriate conda environment
  ;; depends on having this set and NOT `conda-anaconda-home'.
  (gsetq conda-env-home-directory (expand-file-name "~/miniconda3")))

;;; YAML

(use-package yaml-mode
  :mode ("\\.yaml\\'" "\\.yml\\'" "MLproject\\'"))

;;; JSON

;; TODO switch to lsp-json (https://emacs-lsp.github.io/lsp-mode/page/lsp-json/)
(use-package json-mode)

(provide 'init)
;;; init.el ends here
