(setq custom-file "~/.emacs.custom.el")
(load custom-file)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(setq visible-bell t)
(setq ring-bell-function 'ignore)

(evil-mode 1)

(setq evil-normal-state-cursor 'box
      evil-insert-state-cursor 'box
      evil-visual-state-cursor 'box)
(setq evil-want-C-u-scroll t)
(evil-set-undo-system 'undo-redo)
