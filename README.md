# dots

dotfiles.

<img width="1680" height="1050" alt="Screenshot 2026-09-14 at 10 02 53" src="https://github.com/user-attachments/assets/b20ee924-eae9-41fd-9fb8-9592576c4c17" />

</br>

 ## Shell Config

 ### Zsh

 Add to `~/.zshrc`:

```
PROMPT='%F{blue}%~%f %F{white}λ%f '
```

 ### Bash

 Add to `~/.bashrc`:

```
PS1='\[\e[34m\]\w\[\e[0m\] \[\e[37m\]λ\[\e[0m\] '
```

 Both prompts use:

- Blue for the current directory
- White for the `λ` prompt symbol
- Default terminal foreground for typed commands
