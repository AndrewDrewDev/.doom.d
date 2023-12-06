(package! exec-path-from-shell)
(package! copilot
  :recipe (:host github :repo "zerolfx/copilot.el" :files ("*.el" "dist")))


;; disable
(disable-packages! hl-line)
(disable-packages! emmet-mode)
