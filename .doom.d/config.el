;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Roberto Alegro"
      user-mail-address "roberto@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "Fira Code" :size 16))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! :leader ",")

(defvar base-org-dir "/Files/ownCloud/org/roam")

(setq org-roam-directory base-org-dir)
(setq org-directory base-org-dir)
(setq org-agenda-files (list (concat base-org-dir "/daily")))

(defun gen-dailies-template (day)
  "Generate a different thing for different days of the week"
  (concat "#+title: %<%Y-%m-%d>\n"
          "#+ROAM_TAGS:\n\n"
          "* [[roam:Wildlife]] :work:\n"
          "** todo [%]\n\n"
          "** notes\n\n"
          (if (string= day "Friday")
              "* [[roam:Fandelver]] :personal:dnd:fandelver\n" ""
              )
          )
  )


(setq org-roam-dailies-capture-templates
      (let ((head (gen-dailies-template (format-time-string "%A" (current-time)))))
        `(("d" "default" entry
           #'org-roam-capture--get-point
           "* %?"
           :file-name "daily/%<%Y-%m-%d>"
           :head ,head))
        )
      )


(setq org-agenda-start-day nil)

(setq org-agenda-custom-commands '())
(add-to-list 'org-agenda-custom-commands
             '("p" "All Tasks (grouped by Priority)"

               (
                (agenda "" ((org-agenda-span 3)))
                (tags-todo "PRIORITY={A}"
                           ((org-agenda-overriding-header "HIGH")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "PRIORITY={B}"
                           ((org-agenda-overriding-header "NORMAL")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "PRIORITY={C}"
                           ((org-agenda-overriding-header "LOW")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "TODO=\"IDEA\""
                           ((org-agenda-overriding-header "IDEAS")))
                )))
(add-to-list 'org-agenda-custom-commands
             '("w" "Work Tasks (grouped by Priority)"

               (
                (agenda "" ((org-agenda-span 3)))
                (tags-todo "PRIORITY={A}+work-support"
                           ((org-agenda-overriding-header "HIGH")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "PRIORITY={B}+work-support"
                           ((org-agenda-overriding-header "NORMAL")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "PRIORITY={C}+work-support"
                           ((org-agenda-overriding-header "LOW")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "TODO=\"IDEA\"+work-support"
                           ((org-agenda-overriding-header "IDEAS")))
                )))
(add-to-list 'org-agenda-custom-commands
             '("d" "DnD Tasks (grouped by Priority)"
               (
                (tags-todo "PRIORITY={A}+dnd"
                           ((org-agenda-overriding-header "HIGH")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "PRIORITY={B}+dnd"
                           ((org-agenda-overriding-header "NORMAL")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "PRIORITY={C}+dnd"
                           ((org-agenda-overriding-header "LOW")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "TODO=\"IDEA\"+dnd"
                           ((org-agenda-overriding-header "IDEAS")))
                )))
(add-to-list 'org-agenda-custom-commands
             '("o" "Oncall tasks"
               (
                (agenda "" ((org-agenda-span 3)))
                (tags-todo "PRIORITY={A}+oncall"
                           ((org-agenda-overriding-header "INCIDENT")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "PRIORITY={B}+oncall"
                           ((org-agenda-overriding-header "IMPROVEMENT")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "PRIORITY={C}+oncall"
                           ((org-agenda-overriding-header "FALSE POSITIVE")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'todo '("WAITING" "DONE" "IDEA")))))
                (tags-todo "TODO=\"DONE\"+oncall"
                           ((org-agenda-overriding-header "DONE")))
                )))

;; disable startup screen
(setq inhibit-startup-screen t)

;; jk works with visual lines instead of real lines
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

;; Scroll with C-j/k
(define-key evil-normal-state-map (kbd "C-j") 'evil-scroll-line-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-scroll-line-up)

;; Y yanks whole line
(setq! evil-want-Y-yank-to-eol nil)

(define-key evil-normal-state-map (kbd "\\") 'find-file)

;; Disable evil-snipe. Restoring `s` behavior
(after! evil-snipe (evil-snipe-mode -1))

;; evil roam insert
(define-key evil-insert-state-map (kbd "C-i") 'org-roam-insert-immediate)

;; copy and paste to clipboard
(defun copy-to-clipboard ()
  "Copies selection to x-clipboard."
  (interactive)
  (if (display-graphic-p)
      (progn
        (message "Yanked region to x-clipboard!")
        (call-interactively 'clipboard-kill-ring-save)
        )
    (if (region-active-p)
        (progn
          (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
          (message "Yanked region to clipboard!")
          (deactivate-mark))
      (message "No region active; can't yank to clipboard!")))
  )

(defun paste-from-clipboard ()
  "Pastes from x-clipboard."
  (interactive)
  (if (display-graphic-p)
      (progn
        (clipboard-yank)
        (message "graphics active")
        )
    (insert (shell-command-to-string "xsel -o -b"))
    )
  )
(global-set-key (kbd "C-S-c") 'copy-to-clipboard)
(global-set-key (kbd "C-S-v") 'paste-from-clipboard)
