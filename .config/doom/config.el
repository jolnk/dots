;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.







;;SLGHTY
;;
;;


(defun my/run-c-in-vterm ()
  "Compile and run the current C file in a dedicated vterm buffer.
Reuses the same buffer ' *vterm-c-run*'. Handles directories with spaces."
  (interactive)
  (let* ((file (buffer-file-name))
         (dir (file-name-directory file))
         (file-name (file-name-nondirectory file))
         (my-vterm-buffer-name "*vterm-c-run*")
         (cmd (format "cd %s && gcc \"%s\" -o a.out && ./a.out"
                      (shell-quote-argument dir)
                      file-name))
         (vterm-buffer (get-buffer my-vterm-buffer-name)))
    ;; Create or switch to the vterm buffer
    (if (and vterm-buffer (buffer-live-p vterm-buffer))
        (switch-to-buffer-other-window my-vterm-buffer-name)
      (vterm my-vterm-buffer-name))
    ;; Clear vterm buffer and send the compile/run command
    (with-current-buffer my-vterm-buffer-name
      ;;(vterm-send-string "clear" t)
      ;;(vterm-send-return)
      (vterm-send-string cmd t)
      (vterm-send-return))))

(map! :leader
      :desc "Compile and run C in vterm"
      "m 7" #'my/run-c-in-vterm)







;; Function to kill all user buffers except core/default ones

;;(defun my/aggressive-kill-buffers ()
;;  "Kill all buffers except *scratch* and *Messages*."
;;  (interactive)
;;  (dolist (buf (buffer-list))
;;    (let ((name (buffer-name buf)))
;;      (unless (member name '("*doom*" "*scratch*" "*Messages*"))
;;        (when (buffer-live-p buf)
;;          (kill-buffer buf)))))
;;  (message "Nuked all buffers except *scratch* and *Messages*."))
;;
;;(map! :leader
;;      :desc "Nuke all buffers (except *scratch* and *Messages*)"
;;      "b o" #'my/aggressive-kill-buffers)


(defun my/aggressive-kill-buffers-no-confirm ()
  "Kill all buffers except *scratch* and *Messages* without confirmation."
  (interactive)
  (let ((kill-buffer-query-functions nil)) ;; disables the "Save file?" prompt
    (dolist (buf (buffer-list))
      (let ((name (buffer-name buf)))
        (unless (member name '("*doom*" "*scratch*" "*Messages*"))
          (when (buffer-live-p buf)
            (kill-buffer buf))))))
  (message "Nuked all buffers except *scratch* and *Messages* without confirmation."))

(map! :leader
      :desc "Nuke all buffers no confirm"
      "b o" #'my/aggressive-kill-buffers-no-confirm)



(map! :leader
      :desc "Hard restart Emacs"
      "b u" #'restart-emacs)








;;(defun my/compile-and-run-c ()
;;  "Compile and run the current C file."
;;  (interactive)
;;  (when (eq major-mode 'c-mode)
;;    (let* ((file (buffer-file-name))
;;           (output (file-name-sans-extension (file-name-nondirectory file)))
;;           (compile-cmd (format "clang -o \"%s\" \"%s\"" output file))
;;           (run-cmd (format "./%s" output)))
;;      (save-buffer)
;;      (async-shell-command (format "%s && %s" compile-cmd run-cmd)))))
;;
;;(map! :leader
;;      :desc "Compile and run C"
;;      "m a" #'my/compile-and-run-c)











;;(defun my/vterm-compile-and-run-c ()
;;  "Compile and run the current C file in vterm."
;;  (interactive)
;;  (when (eq major-mode 'c-mode)
;;    (let* ((file (buffer-file-name))
;;           (output (file-name-sans-extension (file-name-nondirectory file)))
;;           (compile-cmd (format "clang -o \"%s\" \"%s\" && ./%s" output file output)))
;;      (save-buffer)
;;      (if (get-buffer "*vterm-c*")
;;          (kill-buffer "*vterm-c*"))  ;; Optional: reset buffer
;;      (vterm "*vterm-c*")
;;      (vterm-send-string compile-cmd)
;;      (vterm-send-return))))


;;(map! :leader
;;      :desc "Compile and run C in vterm"
;;      "m c" #'my/vterm-compile-and-run-c)





;;(map! :leader
;;      :desc "Close vterm buffer"
;;      "o k" #'kill-current-buffer)



;;PYTHON
;;
;;

(map! :leader
      :desc "Run Python file"
      "r p" #'python-shell-send-buffer)



;;
;;







;; ─────────────────────────────────────────────────────────────────────────────
;; Function: Compile and run C file in reused ansi-term buffer (async)
;; ─────────────────────────────────────────────────────────────────────────────


(defun my/compile-and-run-c-file ()
  "Compile and run the current C file asynchronously, reusing a single shell buffer."
  (interactive)
  ;; Save the buffer first
  (save-buffer)
  ;;
  (let* ((file (buffer-file-name))
         (file-dir (file-name-directory file))
         (file-base (file-name-base file))
         (output-buf "*my-c-run*")
         (compile-cmd (format "gcc \"%s\" -o \"%s.out\" && \"%s.out\""
                              file
                              (expand-file-name file-base file-dir)
                              (expand-file-name file-base file-dir))))
    ;; Kill buffer if exists to reset it
    (when (get-buffer output-buf)
      (kill-buffer output-buf))
    ;; Run asynchronously and display output
    (async-shell-command compile-cmd output-buf)))

(map! :leader
      :desc "Compile and run C file"
      "m c" #'my/compile-and-run-c-file)





(defun my/compile-and-run-c-file-f ()
  "Compile and run the current C file asynchronously, reusing a single shell buffer and jumping to it."
  (interactive)
  ;; Save the buffer first
  (save-buffer)
  ;;
  (let* ((file (buffer-file-name))
         (file-dir (file-name-directory file))
         (file-base (file-name-base file))
         (output-buf "*my-c-run*")
         (compile-cmd (format "gcc \"%s\" -o \"%s.out\" && \"%s.out\""
                              file
                              (expand-file-name file-base file-dir)
                              (expand-file-name file-base file-dir))))
    ;; Kill the buffer if it exists
    (when (get-buffer output-buf)
      (kill-buffer output-buf))
    ;; Run asynchronously
    (async-shell-command compile-cmd output-buf)
    ;; Switch focus to the output buffer
    (pop-to-buffer output-buf)))

;; Doom Emacs keybinding (SPC m c)
(map! :leader
      :desc "Compile and run C file"
      "m 2" #'my/compile-and-run-c-file-f)







(defun my/blaze-it-c-file ()
  "Compile and run the current C file asynchronously, reusing a single shell buffer.
If the buffer exists and has a running process, kill it without asking and rerun."
  (interactive)
  ;; Save the buffer first
  (save-buffer)
  ;;
  (let* ((file (buffer-file-name))
         (file-dir (file-name-directory file))
         (file-base (file-name-base file))
         (output-buf "*my-c-run*")
         (compile-cmd (format "gcc \"%s\" -o \"%s.out\" && \"%s.out\""
                              file
                              (expand-file-name file-base file-dir)
                              (expand-file-name file-base file-dir)))
         (buf (get-buffer output-buf))
         proc)
    ;; Kill process if running, disabling prompt
    (when buf
      (setq proc (get-buffer-process buf))
      (when proc
        (set-process-query-on-exit-flag proc nil)
        (kill-process proc)))
    ;; Kill the buffer silently
    (when buf
      (kill-buffer buf))
    ;; Run the compile-and-run command asynchronously
    (async-shell-command compile-cmd output-buf)
    ;; Switch focus to the output buffer
    (pop-to-buffer output-buf)))

;; Doom keybinding
(map! :leader
      :desc "Blaze it! Compile and run C file"
      "m 3" #'my/blaze-it-c-file)
