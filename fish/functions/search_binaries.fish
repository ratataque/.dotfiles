#!/bin/fish

function list_binaries_help
    for bin in (command -v * | grep -v '/usr/bin' | xargs -I{} bash -c '{} -h 2>/dev/null')
        echo "$bin"
    end
end

function search_binaries
    set -l search_term (string join ' ' (string split ' ' $argv))
    set -l help_texts (list_binaries_help)
    set -l matches (echo $help_texts | rg -i "$search_term" | awk '{print $1}' | sort -u)

    echo "Matches:"
    echo $matches
end

# fuzzy_search_help "a"
