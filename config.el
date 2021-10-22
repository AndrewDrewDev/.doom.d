;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Indent setting

(setq
 evil-shift-width 2
 tab-width 2
 typescript-indent-level 2
 js-indent-level 2
 js2-basic-offset 2
 web-mode-markup-indent-offset 2
 web-mode-code-indent-offset 2
 web-mode-auto-close-style 2
 )

;; Active russian keyboard layout
(defun reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))

(reverse-input-method 'russian-computer)

(defun xah/open-in-external-app ()
  "Open the current file or dired marked files in external app."
  (interactive)
  (let* (
         (ξfile-list
          (if (string-equal major-mode "dired-mode")
              (dired-get-marked-files)
            (list (buffer-file-name))))
         (ξdo-it-p (if (<= (length ξfile-list) 5)
                       t
                     (y-or-n-p "Open more than 5 files? "))))

    (when ξdo-it-p
      (cond
       ((string-equal system-type "windows-nt")
        (mapc
         (lambda (fPath)
           (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t))) ξfile-list))
       ((string-equal system-type "darwin")
        (mapc
         (lambda (fPath) (shell-command (format "open \"%s\"" fPath)))  ξfile-list))
       ((string-equal system-type "gnu/linux")
        (mapc
         (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath))) ξfile-list)))))
  )

(defun xah/google-translete-word ()
  "The function opens the selected word or several words in Google translator."
  (interactive)
  (require 'browse-url)
  (let (myWord myUrl)
    (setq myWord
          (if (use-region-p)
              (buffer-substring-no-properties (region-beginning) (region-end))
            (thing-at-point 'word)))

    (setq myWord (replace-regexp-in-string " " "%20" myWord))
    (setq myUrl (concat "https://translate.google.ru/#en/ru/" myWord))
    (browse-url myUrl)
    ;; (eww myUrl) ; emacs's own browser
    ))

(defun xah-copy-file-path (&optional @dir-path-only-p)
  "Copy the current buffer's file path or dired path to `kill-ring'. Result is full path."
  (interactive "P")
  (let (($fpath
         (if (string-equal major-mode 'dired-mode)
             (progn
               (let (($result (mapconcat 'identity (dired-get-marked-files) "\n")))
                 (if (equal (length $result) 0)
                     (progn default-directory )
                   (progn $result))))
           (if (buffer-file-name)
               (buffer-file-name)
             (expand-file-name default-directory)))))
    (kill-new
     (if @dir-path-only-p
         (progn
           (message "Directory copied: %s" (file-name-directory $fpath))
           (file-name-directory $fpath))
       (progn
         (message "File path copied: %s" $fpath)
         $fpath )))))

(defun my/dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message "Size of all marked files: %s"
               (progn
                 (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*итого$")
                 (match-string 1))))))

;; Оpen emacs fullscrean
(toggle-frame-maximized)
;; Make parameter emacs frame
;; (set-frame-parameter (selected-frame) 'alpha '(85))

(setq
 doom-font (font-spec :family "Iosevka" :size 10.3)
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
 "M-/"     #'hippie-expand ;; En
 "M-."     #'hippie-expand ;; Ru
 "M-@"     #'er/expand-region
 ;; "<f8>"    #'toggle-truncate-lines
 "M-1"     #'bs-show
 "C-%"     #'query-replace
 "M-%"     #'replace-string
 "C->"     #'mc/mark-next-like-this
 "C-<"     #'mc/mark-previous-like-this

 ;; My/Custom keybindings (have external functions)
 "C-x 4 e" #'xah/open-in-external-app
 "\e\e g"  #'xah/google-translete-word
 "\e\e p"  #'xah-copy-file-path

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

(use-package! prettier
  :defer t
  :init
  (add-hook 'after-init-hook #'global-prettier-mode))


(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
