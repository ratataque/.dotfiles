function __zoxide_select
    # Combine zoxide-ranked directories with directories from fd
    set -l combined_list (begin; zoxide query --all; fd -d 1 --type d . ~/.config/; end | sort | uniq)

    # Use fzf to select from the combined list
    set -l selected (echo "$combined_list" | fzf)

    # If a directory was selected, change to that directory
    if test -n "$selected"
        cd $selected
    end
end
