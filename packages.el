;; install
(package! exec-path-from-shell)
(package! copilot :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("dist" "*.el")))

;; disable
(disable-packages! hl-line)
(disable-packages! emmet-mode)
