tmux attach -t "dev" \; run-shell "sesh connect \"$(
 sesh list | fzf-tmux -p 55%,60% \
 --no-sort --border-label ' sesh ' --prompt '⚡  ' \
 --header '  ^e all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find ^a mkdir' \
 --bind 'ctrl-e:change-prompt(⚡  )+reload(sesh list)' \
 --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
 --bind 'ctrl-g:change-prompt(⚙️   )+reload(sesh list -c)' \
 --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
 --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -t d -E .cache . / | sed "s,^$HOME,~,")' \
 --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡  )+reload(sesh list)' \
 --bind 'ctrl-a:execute(mkdir -p {q})+change-prompt(⚡  )+reload(sesh list)' \
 )\""
