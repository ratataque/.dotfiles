# function vpn
#     echo "Starting VPN connection..."
#     set -l USERNAME (op item get "VPN-SSL-REMOTE-ACCESS User grimaldev" --fields username)
#     set -l PASSWORD (op item get "VPN-SSL-REMOTE-ACCESS User grimaldev" --fields password)
#
#     # Fish doesn't have process substitution, so we use bash for that part
#     # sudo bash -c "openvpn --config /etc/openvpn/client/ewan_grimaldev.ovpn --auth-user-pass <(echo -e \"$USERNAME\n$PASSWORD\")"
#     echo -e "$USERNAME\n$PASSWORD"
#
# end

function vpn
    echo "🔍 Starting VPN connection with fuzzy finder..."

    # Define VPN configurations directory
    set -l VPN_CONFIG_DIR /etc/openvpn/client

    # Get available VPN configs and use fzf to select one
    set -l available_configs (sudo find $VPN_CONFIG_DIR -name "*.ovpn" -exec basename {} .ovpn \; 2>/dev/null | sort)

    if test (count $available_configs) -eq 0
        echo "❌ No VPN configurations found in $VPN_CONFIG_DIR"
        return 1
    end

    # Use fzf to select VPN config
    set -l selected_vpn (printf '%s\n' $available_configs | fzf \
        --height=40% \
        --reverse \
        --border \
        --prompt="🔒 Select VPN: " \
        --preview="echo '📄 Config: {}.ovpn'; echo; head -10 '$VPN_CONFIG_DIR/{}.ovpn' 2>/dev/null | grep -E '^(remote|auth-user-pass|cipher|proto)' || echo '❌ Preview not available'" \
        --preview-window=right:50%:wrap)

    if test -z "$selected_vpn"
        echo "❌ No VPN selected. Exiting."
        return 0
    end

    echo "✅ Selected VPN: $selected_vpn"

    # Map VPN configs to their corresponding 1Password entries
    # You can customize this mapping based on your 1Password item names
    set -l op_item_name
    switch $selected_vpn
        case grimaldev_grimaldev
            set op_item_name "VPN grimaldev - User grimaldev"
        case ewan_grimaldev
            set op_item_name "VPN grimaldev - user ewan"
        case ewan_grimmely
            set op_item_name "VPN grimmely - User ewan"
        case "*"
            # Default pattern - fail 
            echo "❌ No matching 1Password item for selected VPN config '$selected_vpn'"
            return 1
    end

    echo "🔑 Fetching credentials for: $op_item_name"

    # Get credentials from 1Password
    set -l USERNAME (op item get "$op_item_name" --fields username 2>/dev/null)
    set -l PASSWORD (op item get "$op_item_name" --fields password 2>/dev/null)

    if test -z "$USERNAME" -o -z "$PASSWORD"
        echo "❌ Failed to retrieve credentials from 1Password for '$op_item_name'"
        echo "Available 1Password items containing 'VPN':"
        op item list --categories Login | grep -i vpn
        return 1
    end

    echo "👤 Username retrieved: $USERNAME"
    echo "🔒 Password retrieved: [HIDDEN]"

    set -l config_file "$VPN_CONFIG_DIR/$selected_vpn.ovpn"

    if not sudo test -f "$config_file"
        echo "❌ Config file not found: $config_file"
        return 1
    end

    echo "🚀 Connecting to VPN with config: $config_file"
    echo "⏹️  Press Ctrl+C to disconnect"
    echo "────────────────────────────────────────"

    # Create temporary credential file
    # set -l temp_creds (mktemp)
    # echo -e "$USERNAME\n$PASSWORD" >$temp_creds

    # Ensure temp file is cleaned up
    # trap "rm -f $temp_creds" EXIT

    # Connect to VPN
    # sudo openvpn --config "$config_file" --auth-user-pass "$temp_creds"
    sudo bash -c "openvpn --config '$config_file' --auth-user-pass <(printf '%s\n%s\n' '$USERNAME' '$PASSWORD')"

    # Clean up
    # rm -f "$temp_creds"
end
