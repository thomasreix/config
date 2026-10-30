
#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config"
SOURCE="$CONFIG/binds"
OUTPUT="$CONFIG/niri/binds.kdl"

if [[ ! -f $SOURCE ]]; then
    printf 'Cannot find %s\n' "$SOURCE" >&2
    exit 1
fi

declare -A aliases=()
declare -A seen=()

trim() {
    local value=$1
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    printf '%s' "$value"
}

kdl_quote() {
    local value=$1
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    value=${value//$'\n'/\\n}
    printf '"%s"' "$value"
}

parse_key() {
    local compact part result='' i
    local -a parts=()

    compact=${1//[[:space:]]/}
    IFS='+' read -r -a parts <<< "$compact"

    for ((i = 0; i < ${#parts[@]}; i++)); do
        part=${parts[i]}

        if ((i < ${#parts[@]} - 1)); then
            case "${part,,}" in
                super) part=Super ;;
                shift) part=Shift ;;
                ctrl|control) part=Ctrl ;;
                alt) part=Alt ;;
                altgr) part=Mod5 ;;
                *)
                    printf 'Unknown modifier: %s\n' "$part" >&2
                    return 1
                    ;;
            esac
        else
            case "${part,,}" in
                backspace) part=BackSpace ;;
                grave) part=grave ;;
                scrollup) part=WheelScrollUp ;;
                scrolldown) part=WheelScrollDown ;;
                left) part=Left ;;
                right) part=Right ;;
                up) part=Up ;;
                down) part=Down ;;
                return) part=Return ;;
                print) part=Print ;;
                f[0-9]*) part=${part^^} ;;
                *)
                    if ((${#part} == 1)); then
                        part=${part^^}
                    fi
                    ;;
            esac
        fi

        [[ -n $result ]] && result+="+"
        result+="$part"
    done

    printf '%s' "$result"
}

spawn_action() {
    local result='spawn' arg

    for arg in "$@"; do
        result+=" $(kdl_quote "$arg")"
    done

    printf '%s' "$result"
}

expand_aliases() {
    local command=$1 name value

    for name in "${!aliases[@]}"; do
        value=${aliases[$name]}

        command=$(printf '%s\n' "$command" |
            sed -E "s/(^|[^[:alnum:]_])${name}([^[:alnum:]_]|$)/\\1${value}\\2/g")
    done

    printf '%s' "$command"
}

translate() {
    local command=$1 action name direction
    local url escaped_url shell_command
    local browser browser_id browser_exec browser_exec_q
    local website_function

    local -a parts=() browser_parts=() app_parts=()

    action=${command,,}
    action=${action//_/-}

    case "$action" in
        close) printf 'close-window'; return ;;
        overview) printf 'toggle-overview'; return ;;
        quit) printf 'quit skip-confirmation=true'; return ;;

        sleep) spawn_action systemctl suspend; return ;;
        restart) spawn_action systemctl reboot; return ;;
        shutdown) spawn_action systemctl poweroff; return ;;

        resize) printf 'switch-preset-column-width'; return ;;
        fullscreen) printf 'fullscreen-window'; return ;;

        screenshot-screen) printf 'screenshot-screen'; return ;;
        screenshot-window) printf 'screenshot-window'; return ;;
        screenshot-selection) printf 'screenshot'; return ;;

        screenshot-text)
            printf 'spawn-sh %s' \
                "$(kdl_quote 'grim -g "$(slurp)" - | tesseract stdin stdout | wl-copy')"
            return
            ;;

        border) return ;;
    esac

    # Window and workspace actions.
    if [[ $action =~ ^(window|move-window|workspace|move-workspace|move-window-to-workspace)\[(\+1|-1|[0-9]+|!)\]$ ]]; then
        name=${BASH_REMATCH[1]}
        direction=${BASH_REMATCH[2]}

        # Convert zero-based indices to Niri's one-based indices.
        if [[ $direction =~ ^[0-9]+$ ]]; then
            direction=$((direction + 1))

            case "$name" in
                window) printf 'focus-column-first' ;;
                move-window) printf 'move-column-to-first' ;;
                workspace) printf 'focus-workspace %s' "$direction" ;;
                move-workspace) printf 'move-workspace-to-index %s' "$direction" ;;
                move-window-to-workspace) printf 'move-window-to-workspace %s' "$direction" ;;
            esac

            return
        fi

        case "$name:$direction" in
            window:+1) printf 'focus-column-right' ;;
            window:-1) printf 'focus-column-left' ;;
            window:0) printf 'focus-column-first' ;;
            window:!) printf 'focus-column-last' ;;

            move-window:+1) printf 'move-column-right' ;;
            move-window:-1) printf 'move-column-left' ;;
            move-window:0) printf 'move-column-to-first' ;;
            move-window:!) printf 'move-column-to-last' ;;

            workspace:+1) printf 'focus-workspace-down' ;;
            workspace:-1) printf 'focus-workspace-up' ;;
            workspace:0) printf 'focus-workspace 1' ;;
            workspace:!) printf 'focus-workspace 10' ;;

            move-workspace:+1) printf 'move-workspace-down' ;;
            move-workspace:-1) printf 'move-workspace-up' ;;
            move-workspace:0) printf 'move-workspace-to-index 1' ;;
            move-workspace:!) printf 'move-workspace-to-index 10' ;;

            move-window-to-workspace:+1) printf 'move-window-to-workspace-down' ;;
            move-window-to-workspace:-1) printf 'move-window-to-workspace-up' ;;
            move-window-to-workspace:0) printf 'move-window-to-workspace 1' ;;
            move-window-to-workspace:!) printf 'move-window-to-workspace 10' ;;
        esac

        return
    fi

    # Browser configuration.
    browser=${aliases[browser]:-librewolf}
    read -r -a browser_parts <<< "$browser"

    browser_exec=${browser_parts[0]:-librewolf}
    browser_id=${browser_exec##*/}

    printf -v browser_exec_q '%q' "$browser_exec"

    # Website shortcuts.
    if [[ $command =~ (https?://[^[:space:]]+) ]]; then
        url=${BASH_REMATCH[1]}
        printf -v escaped_url '%q' "$url"

        shell_command=${command/"$url"/"website $escaped_url"}
        shell_command=$(expand_aliases "$shell_command")

        website_function="website() {
    url=\$1

    if niri msg -j focused-window 2>/dev/null | grep -Eiq '\"app_id\"[[:space:]]*:[[:space:]]*\"[^\"]*${browser_id}'; then
        ${browser_exec_q} --new-tab \"\$url\"
    else
        ${browser_exec_q} --new-window \"\$url\"
    fi
}"

        printf 'spawn-sh %s' \
            "$(kdl_quote "$website_function; $shell_command")"

        return
    fi

    # Commands containing shell operators.
    if [[ $command == *'&&'* || $command == *'||'* || $command == *'|'* || $command == *';'* ]]; then
        shell_command=$(expand_aliases "$command")
        printf 'spawn-sh %s' "$(kdl_quote "$shell_command")"
        return
    fi

    # Ordinary application commands.
    read -r -a parts <<< "$command"
    ((${#parts[@]})) || return

    name=${parts[0],,}

    if [[ ${aliases[$name]+present} ]]; then
        read -r -a app_parts <<< "${aliases[$name]}"
        parts=("${app_parts[@]}" "${parts[@]:1}")
    fi

    spawn_action "${parts[@]}"
}

# Read application aliases.
while IFS= read -r line || [[ -n $line ]]; do
    line=$(trim "$line")
    [[ -z $line || $line == \#* || $line == //* ]] && continue

    if [[ $line =~ ^([[:alpha:]_][[:alnum:]_]*)[[:space:]]*=[[:space:]]*(.*)$ ]]; then
        name=${BASH_REMATCH[1],,}
        aliases[$name]=$(trim "${BASH_REMATCH[2]}")
    fi
done < "$SOURCE"

# Generate Niri configuration.
TEMP_OUTPUT=$(mktemp)
trap 'rm -f "$TEMP_OUTPUT"' EXIT

{
    printf '// Generated from ~/.config/binds. Do not edit directly.\n\n'
    printf 'binds {\n'

    while IFS= read -r line || [[ -n $line ]]; do
        line=$(trim "$line")
        [[ -z $line || $line == \#* || $line == //* ]] && continue

        # Skip application aliases.
        if [[ $line =~ ^([[:alpha:]_][[:alnum:]_]*)[[:space:]]*=[[:space:]]*(.*)$ ]]; then
            name=${BASH_REMATCH[1],,}
            [[ ${aliases[$name]+present} ]] && continue
        fi

        # Parse a shortcut with or without '='.
        if [[ $line =~ ^([[:alnum:]_[:space:]+]+)[[:space:]]*=[[:space:]]*(.*)$ ]]; then
            hotkey=$(trim "${BASH_REMATCH[1]}")
            command=$(trim "${BASH_REMATCH[2]}")
        elif [[ $line =~ ^(.+)[[:space:]]+(https?://.*)$ ]]; then
            hotkey=$(trim "${BASH_REMATCH[1]}")
            command=$(trim "${BASH_REMATCH[2]}")
        else
            printf 'Skipping unrecognized line: %s\n' "$line" >&2
            continue
        fi

        if ! key=$(parse_key "$hotkey"); then
            continue
        fi

        # Skip duplicate shortcuts.
        if [[ ${seen[$key]+present} ]]; then
            printf 'Duplicate key skipped: %s (%s)\n' "$key" "$command" >&2
            continue
        fi

        seen[$key]=1

        action=$(translate "$command")

        if [[ -z $action ]]; then
            printf '    // TODO: %s = %s (unsupported)\n' "$hotkey" "$command"
            printf 'Unsupported action: %s\n' "$command" >&2
            continue
        fi

        cooldown=''
        [[ $key == *WheelScroll* ]] && cooldown=' cooldown-ms=150'

        printf '    %s%s { %s; }\n' "$key" "$cooldown" "$action"

    done < "$SOURCE"

    printf '}\n'
} > "$TEMP_OUTPUT"

mkdir -p "$(dirname "$OUTPUT")"
mv "$TEMP_OUTPUT" "$OUTPUT"
trap - EXIT

printf 'Generated %s\n' "$OUTPUT"
