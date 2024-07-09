
;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a link to Doom's Module Index where all
;;      of our modules are listed, including what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).

(doom! :completion
       (company +childframe)           ; the ultimate code completion backend
       (vertico +icons)           ; the search engine of the future

       :ui
       doom              ; what makes DOOM look the way it does
       (emoji +unicode)  ; 🙂
       hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       (modeline +light)          ; snazzy, Atom-inspired modeline, plus API
       nav-flash         ; blink cursor line after big motions
       ophints           ; highlight the region an operation acts on
       (popup +defaults)   ; tame sudden yet inevitable temporary windows
       unicode           ; extended unicode support for various languages
       (vc-gutter +pretty) ; vcs diff in the fringe
       vi-tilde-fringe   ; fringe tildes to mark beyond EOB

       :editor
       ;;(evil +everywhere); come to the dark side, we have cookies
       file-templates    ; auto-snippets for empty files
       (format +onsave)  ; automated prettiness
       multiple-cursors  ; editing in many places at once
       snippets          ; my elves. They type so I don't have to

       :emacs
       (dired +icons)             ; making dired pretty [functional]
       electric          ; smarter, keyword-based electric-indent
       undo              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control and Emacs, sitting in a tree

       :checkers
       (syntax +childframe)              ; tasing you for every semicolon you forget

       :tools
       (debugger +lsp)          ; FIXME stepping through code, to help you add bugs
       (docker +lsp)
       editorconfig        ; let someone else argue about tabs vs spaces
       (eval +overlay)     ; run code, run (also, repls)
       lookup              ; navigate your code and its documentation
       (lsp +peek)               ; M-x vscode
       magit               ; a git porcelain for Emacs
       pass                ; password manager for nerds
       upload              ; map local to remote projects via ssh/ftp

       :os
       (:if IS-MAC macos)  ; improve compatibility with macOS
       tty               ; improve the terminal Emacs experience

       :lang
       data                ; config/data formats
       emacs-lisp          ; drown in parentheses
       json                ; At least it ain't XML
       (javascript +lsp)        ; all(hope(abandon(ye(who(enter(here))))))
       markdown          ; writing docs for people to ignore
       (org +dragndrop +present)               ; organize your plain life in plain text
       python              ; beautiful is better than ugly
       (sh +lsp +fish)                ; she sells {ba,z,fi}sh shells on the C xor
       (web +lsp)               ; the tubes
       yaml              ; JSON, but readable

       :config
       (default +bindings +smartparens))
