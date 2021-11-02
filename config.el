;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "+functions")

;; Make emacs transparency
;; (set-frame-parameter (selected-frame) 'alpha '(90 90))

;; Оpen emacs fullscrean
(toggle-frame-maximized)

(setq
 ;; doom-font (font-spec :family "Iosevka" :size 10.3)
 doom-font (font-spec :family "JetBrains Mono" :size 10.0)
 doom-theme 'doom-dracula
 org-directory "~/DA/Org/"
 ;; Disable view left display line number
 display-line-numbers-type nil
 ;; Итеремещении на camelCase
 global-subword-mode t
 ;; Настройка растояния в 10 символов отступа от верха при скролинге.
 scroll-margin 10
 ;; Share copy ring with system
 save-interprogram-paste-before-kill t
 ;; isearch matching counter
 isearch-lazy-count t
 ;; Dont create file ".log" for js files
 lsp-clients-typescript-server-args '("--stdio" "--tsserver-log-file" "/dev/stderr")
 ;; Path to bookmark file
 bookmark-file "~/.doom.d/bookmarks"
 ;; Высота modelibe +light
 +modeline-height 25
 ;; Show *scratch* в bs
 bs-configurations
 '(("files" "^\\*scratch\\*" nil nil bs-visits-non-file bs-sort-buffer-interns-are-last))

 ;; Indent setting
 tab-width 2
 typescript-indent-level 2
 js-indent-level 2
 web-mode-markup-indent-offset 2
 web-mode-code-indent-offset 2
 web-mode-auto-close-style 2
 )

(after! dired
  ;; Add .. and . to dired
  (remove-hook! 'dired-mode-hook 'dired-omit-mode nil)
  ;; (add-hook! 'dired-mode-hook 'dired-hide-details-mode)

  (setq
   ;; Всегда рекурсивное копирование
   dired-recursive-deletes 'always
   ;; Перемещать файлы в корзину при удаленнии
   delete-by-moving-to-trash t

   ;; dired-listing-switches "-ahl -v"
   )
  )

(after! org
  (setq
   ;; Add LOGBOOK drawer
   org-log-into-drawer "LOGBOOK"
   ;; Hide headers after open file
   org-startup-folded t
   ;; Allow inline image previews of http(s)? urls or data uris.
   org-display-remote-inline-images 'skip
   ))

(map!
 ;; Doom/Vanila keybindings
 "C-z" nil
 "C-S-W"       #'kill-whole-line
 "M-/"       #'hippie-expand ;; En
 "M-."       #'hippie-expand ;; Ru
 "M-@"       #'er/expand-region
 ;; "<f8>"   #'toggle-truncate-lines
 "M-1"       #'bs-show
 "C-%"       #'query-replace
 "M-%"       #'replace-string
 "C->"       #'mc/mark-next-like-this
 "C-<"       #'mc/mark-previous-like-this

 ;; My/Custom keybindings (have external functions)
 "C-x 4 e"   #'xah/open-in-external-app
 "\e\e g"    #'xah/google-translete-word
 "\e\e p"    #'xah-copy-file-path
 "C-S-d"     #'dr/duplicate-current-line
 "ESC ESC t" #'dr/all-insert-date-time

 ;; TODO: Ask father for a function
 ;; "\e\e s" #'my/search-in-browser

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

;; Pack/unpack files with atool on dired.
(use-package! dired-atool
  :defer t
  :init
  (dired-atool-setup))

;; Format buffer using some formatters
(use-package! apheleia
  :defer t
  :init
  (apheleia-global-mode +1))

;; tree-sitter - parser for all language
(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
