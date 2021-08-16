;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(defun my/indent-buffer()
  (interactive)
  (indent-region (point-min) (point-max)))

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

(defun dr/dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message "Size of all marked files: %s"
               (progn
                 (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*итого$")
                 (match-string 1))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Оpen emacs fullscrean
(toggle-frame-maximized)

;; Active russian keyboard
(reverse-input-method 'russian-computer)

(setq user-full-name "Andrew Drew"
      user-mail-address "john@doe.com"
      doom-font (font-spec :family "Iosevka" :size 10.3)
      doom-theme 'doom-one
      ;; If you use `org' and don't want your org files in the default location below,
      ;; change `org-directory'. It must be set before org loads!
      org-directory "~/DA/Org/"
      ;; This determines the style of line numbers in effect. If set to `nil', line
      ;; numbers are disabled. For relative line numbers, set this to `relative'.
      display-line-numbers-type nil
      ;; Итеремещении на camelCase
      global-subword-mode t
      ;; Настройка растояния в 10 символов отступа от верха при скролинге.
      scroll-margin 10
      ;; Включение общего буфера обмена с Emacs
      save-interprogram-paste-before-kill t
      ;; isearch matching counter
      isearch-lazy-count t
      ;; Dont create file ".log" for js files
      lsp-clients-typescript-server-args '("--stdio" "--tsserver-log-file" "/dev/stderr")
      ;; Path to bookmark file
      bookmark-file "~/.doom.d/bookmarks"
      ;; Высота modelibe +light
      +modeline-height 25
      ;; Отображение буфера *scratch* в bs
      bs-configurations
      '(("files" "^\\*scratch\\*" nil nil bs-visits-non-file bs-sort-buffer-interns-are-last))
      )

(after! dired
  ;; Удаление скрытия . .. в дирете
  (remove-hook! 'dired-mode-hook 'dired-omit-mode nil)

  ;; Автоматическое скрытие дополнительной информации
  ;; (add-hook! 'dired-mode-hook 'dired-hide-details-mode)


  (setq
   ;; Всегда рекурсивное копирование
   dired-recursive-deletes 'always
   ;; Перемещать файлы в корзину при удаленнии
   delete-by-moving-to-trash t

   ;; Формат отображения каталогов в =Dired=
   ;; Параметр -ahl --time-style=long-iso - вызывает проблемы с
   ;; отображением под Windows
   ;; dired-listing-switches "-ahl -v"
   )

  (map! :map dired-mode-map
        ;; Raname Files
        "r"  #'dired-toggle-read-only
        ;; Get files size or size of grop marked files
        "?"  #'dr/dired-get-size
        ;; Move higher in the file system tree
        "b"  #'dired-jump
        ;; Replace native emacs copy function on rsync
        "C"  #'dired-rsync))

(after! org
  (setq
   ;; Add LOGBOOK
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
 "<f8>"    #'toggle-truncate-lines
 "M-1"          #'bs-show
 "C-%" #'query-replace
 "M-%" #'replace-string
 "C->" #'mc/mark-next-like-this
 "C-<" #'mc/mark-previous-like-this

 ;; My/Custom keybindings (have external functions)
 "C-x 4 e" #'xah/open-in-external-app
 "\e\e g" #'xah/google-translete-word
 "\e\e p" #'xah-copy-file-path
 "C-M-|" #'my/indent-buffer ;; En
 "C-M-/" #'my/indent-buffer ;; Ru

 ;; TODO: Ask father for a function
 ;; "\e\e s" #'my/search-in-browser
 )

;; Pack/unpack files with atool on dired.
(use-package! dired-atool
  :defer t
  :init
  (dired-atool-setup))