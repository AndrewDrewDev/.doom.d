
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(load! "+functions")

;; open emacs fullscrean
(toggle-frame-maximized)

(setq
 doom-font (font-spec :family "Fira Code" :size 14.0)
 doom-theme 'doom-dracula
 ;; Disable view left display line number
 display-line-numbers-type nil
 ;; Итеремещении на camelCase
 global-subword-mode t
 ;; Настройка растояния в 10 символов отступа от верха при скролинге.
 scroll-margin 10
 ;; isearch matching counter
 isearch-lazy-count t
 ;; Show *scratch* в bs
 bs-configurations '(("files" "^\\*scratch\\*" nil nil bs-visits-non-file bs-sort-buffer-interns-are-last))

 ;; set default gpg program
 epg-gpg-program "gpg2"

 ;; Macos
 mac-command-modifier 'meta

 ;; tab width
 tab-width 4
 )

(after! doom-theme
  ;; Позволяет удалять текущий буфер как в стандартном Emacs
  (remove-hook! 'kill-buffer-hook 'centaur-tabs-buffer-track-killed))


(after! dired
  ;; Add .. and . to dired
  (remove-hook! 'dired-mode-hook 'dired-omit-mode nil)
  (add-hook! 'dired-mode-hook 'dired-hide-details-mode)

  (setq
   ;; Всегда рекурсивное копирование
   dired-recursive-deletes 'always
   ;; Перемещать файлы в корзину при удаленнии
   delete-by-moving-to-trash t
   )
  )

(after! dired
  ;; Add .. and . to dired
  (remove-hook! 'dired-mode-hook 'dired-omit-mode nil)
  (add-hook! 'dired-mode-hook 'dired-hide-details-mode)

  (setq
   ;; Всегда рекурсивное копирование
   dired-recursive-deletes 'always
   ;; Перемещать файлы в корзину при удаленнии
   delete-by-moving-to-trash t
   ;; Исправляет ошибку *(rsync) в dired
   dired-rsync-options "-az"
   )
  )


(after! org
  (setq
   ;; Hide headers after open file
   org-startup-folded t
   ;; Allow inline image previews of http(s)? urls or data uris.
   org-display-remote-inline-images 'skip
   ;; Add logbook drawer
   org-log-into-drawer t
   ))

(map!
 ;; Doom/Vanila keybindings
 "C-z" nil
 "C-S-W"       #'kill-whole-line
 "M-/"         #'hippie-expand ;; En
 "M-."         #'hippie-expand ;; Ru
 "M-@"         #'er/expand-region
 "M-1"         #'bs-show
 "C-%"         #'replace-string
 "C->"         #'mc/mark-next-like-this
 "C-<"         #'mc/mark-previous-like-this
 "<M-right>"   #'other-window
 "<M-left>"    #'+popup/other

 ;; My/Custom keybindings (have external functions)
 "C-x 4 e"   #'xah/open-in-external-app
 "\e\e p"    #'xah-copy-file-path
 "C-S-d"     #'dr/duplicate-current-line
 "ESC ESC t" #'dr/all-insert-date-time

 :map dired-mode-map
 ;; Raname Files
 "r"  #'dired-toggle-read-only
 ;; Get files size or size of grop marked files
 "?"  #'my/dired-get-size
 ;; Move higher in the file system tree
 "b"  #'dired-jump
 ;; Replace native emacs copy function on rsync
 "C"  #'dired-rsync
 )

;; Add exec paths to macos
(use-package! exec-path-from-shell
  :defer t
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; default gpg package
(use-package! epa
  :defer t
  :config
  ;; fix bug for emacs 29.1
  (fset 'epg-wait-for-status 'ignore))

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)
              ("C-n" . 'copilot-next-completion)
              ("C-p" . 'copilot-previous-completion)))


;; Enable native compilation
(setq package-native-compile t)
