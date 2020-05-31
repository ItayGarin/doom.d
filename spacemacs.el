;;; ~/.doom.d/spacemacs.el -*- lexical-binding: t; -*-

;; ----------------------------------------------------------
;; -------------- Spacemacs Compatability -------------------
;; ----------------------------------------------------------

(setq-default evil-escape-key-sequence "fd")

(map! :leader "SPC" 'counsel-M-x)
(map! :leader "f f" 'projectile-find-file)
(map! :leader "f F" 'find-file)

(map! :leader "w m" 'doom/window-maximize-buffer)
(map! :leader "g s" 'magit-status)

;; Instead of "C-w" (doom/delete-backward-word)
(define-key! ivy-minibuffer-map
  "C-h" #'ivy-backward-kill-word)

;; ----------------- alternate buffer --------------------
;;
(defun spacemacs/alternate-buffer (&optional window)
  "Switch back and forth between current and last buffer in the
current window."
  (interactive)
  (let ((current-buffer (window-buffer window))
        (buffer-predicate
         (frame-parameter (window-frame window) 'buffer-predicate)))
    ;; switch to first buffer previously shown in this window that matches
    ;; frame-parameter `buffer-predicate'
    (switch-to-buffer
     (or (cl-find-if (lambda (buffer)
                       (and (not (eq buffer current-buffer))
                            (or (null buffer-predicate)
                                (funcall buffer-predicate buffer))))
                     (mapcar #'car (window-prev-buffers window)))
         ;; `other-buffer' honors `buffer-predicate' so no need to filter
         (other-buffer current-buffer t)))))

(map! :leader "TAB" 'spacemacs/alternate-buffer)

;; ----------------- isearch remove highlight --------------------

(defun spacemacs/evil-search-clear-highlight ()
  "Clear evil-search or evil-ex-search persistent highlights."
  (interactive)
  (case evil-search-module
    ('isearch (evil-search-highlight-persist-remove-all))
    ('evil-search (evil-ex-nohighlight))))

(map! :leader "s c" 'spacemacs/evil-search-clear-highlight)

(provide 'spacemacs)
