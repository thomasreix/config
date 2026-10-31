#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config"
SOURCE="$CONFIG/binds"
OUTPUT="$CONFIG/niri/binds.kdl"

HELPER="$HOME/.local/bin/librewolf-open"

mkdir -p "$HOME/.local/bin"

cat > "$HELPER" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

url=$1

app_id=$(
    niri msg --json focused-window 2>/dev/null |
        python3 -c '
import json
import sys

try:
    data = json.load(sys.stdin)
    print(data.get("app_id") or "")
except (json.JSONDecodeError, AttributeError, TypeError):
    print("")
'
) || app_id=""

if [[ "${app_id,,}" == *librewolf* ]]; then
    exec librewolf --new-tab "$url"
else
    exec librewolf --new-window "$url"
fi
EOF

chmod +x "$HELPER"

function parse_word() {
    local configuration=$1
    local objective=$2
    local position=0
    local word=""
    local character
    local i=0
    local in_word=0
    while (( i < ${#configuration} )); do
        character=${configuration:i:1}
        if [[ $character =~ [[:space:]] ]]; then
            if (( in_word )); then
                if (( position == objective )); then
                    break
                fi
                ((++position))
                in_word=0
            fi
        else
            in_word=1
            if (( position == objective )); then
                word+="$character"
            fi
        fi
        ((++i))
    done
    echo "$word"
}

function parse_value() {
    local configuration=$1
    local word=$2
    local i=0
    local current_word
    local value
    while (( i < ${#configuration} )); do
        current_word=$(parse_word "$configuration" "$i")
        if [[ -z $current_word ]]; then
            break
        fi
        if [[ $current_word == "$word" ]]; then
            value=$(parse_word "$configuration" "$((i + 2))")
            echo "$value"
            return
        fi
        ((++i))
    done
}

function is_website() {
    link=$1
    https="${link:0:5}"
    if [[ "$https" == "https" ]]; then
        return 0
    fi
    return 1
}

function parse_command() {
    local command=$1
    local -A commands=(
        ["border"]=""
        ["close-window"]="close-window"
        ["fullscreen"]="fullscreen-window"
        ["move-window-first"]="move-column-to-first"
        ["move-window-last"]="move-column-to-last"
        ["move-window-next"]="move-column-right"
        ["move-window-prev"]="move-column-left"
        ["move-window-to-workspace-0"]="move-column-to-workspace 1"
        ["move-window-to-workspace-1"]="move-column-to-workspace 2"
        ["move-window-to-workspace-2"]="move-column-to-workspace 3"
        ["move-window-to-workspace-3"]="move-column-to-workspace 4"
        ["move-window-to-workspace-4"]="move-column-to-workspace 5"
        ["move-window-to-workspace-5"]="move-column-to-workspace 6"
        ["move-window-to-workspace-6"]="move-column-to-workspace 7"
        ["move-window-to-workspace-7"]="move-column-to-workspace 8"
        ["move-window-to-workspace-8"]="move-column-to-workspace 9"
        ["move-window-to-workspace-9"]="move-column-to-workspace 10"
        ["move-window-to-workspace-next"]="move-column-to-workspace-down"
        ["move-window-to-workspace-prev"]="move-column-to-workspace-up"
        ["move-workspace-next"]="move-workspace-down"
        ["move-workspace-prev"]="move-workspace-up"
        ["overview"]="toggle-overview"
        ["quit"]="quit"
        ["resize"]="reset-window-height"
        ["restart"]="spawn \"systemctl\" \"reboot\""
        ["screenshot-screen"]="screenshot-screen"
        ["screenshot-window"]="screenshot-window"
        ["screenshot-selection"]='spawn-sh "geometry=\"$(slurp)\" && [ -n \"$geometry\" ] && { mkdir -p \"$HOME/screenshots\"; grim -g \"$geometry\" - | tee \"$HOME/screenshots/$(date +%d-%m-%y_%H-%M-%S).png\" | wl-copy --type image/png; }"'
        ["screenshot-text"]='spawn-sh "grim -g \"$(slurp)\" - | tesseract stdin stdout 2>/dev/null | wl-copy"'
        ["sleep"]="power-off-monitors"
        ["shutdown"]="spawn \"systemctl\" \"poweroff\""
        ["window-first"]="focus-column-first"
        ["window-last"]="focus-column-last"
        ["window-next"]="focus-column-right"
        ["window-prev"]="focus-column-left"
        ["workspace-0"]="focus-workspace 1"
        ["workspace-1"]="focus-workspace 2"
        ["workspace-2"]="focus-workspace 3"
        ["workspace-3"]="focus-workspace 4"
        ["workspace-4"]="focus-workspace 5"
        ["workspace-5"]="focus-workspace 6"
        ["workspace-6"]="focus-workspace 7"
        ["workspace-7"]="focus-workspace 8"
        ["workspace-8"]="focus-workspace 9"
        ["workspace-9"]="focus-workspace 10"
        ["workspace-next"]="focus-workspace-down"
        ["workspace-prev"]="focus-workspace-up"
    )
    if is_website "$command"; then
        command=" { spawn \"~/.local/bin/librewolf-open\" \"$command\"; }"
    elif [[ ${commands["$command"]+exists} ]]; then
        command=${commands["$command"]}
        command=" { "$command"; }"
    else
        command=" { spawn \""$command"\"; }"
    fi
    echo "$command"
}

function parse_key() {
    local key=$1
    local -A keys=( 
        ["0"]="0"
        ["1"]="1"
        ["2"]="2"
        ["3"]="3"
        ["4"]="4"
        ["5"]="5"
        ["6"]="6"
        ["7"]="7"
        ["8"]="8"
        ["9"]="9"
        ["A"]="A"
        ["Alt"]="Alt"
        ["AltGr"]="Mod5"
        ["B"]="B"
        ["Backspace"]="Backspace"
        ["C"]="C"
        ["Ctrl"]="Ctrl"
        ["D"]="D"
        ["Down"]="Down"
        ["E"]="E"
        ["Enter"]="Return"
        ["F"]="F"
        ["F1"]="F1"
        ["F2"]="F2"
        ["F3"]="F3"
        ["F4"]="F4"
        ["F5"]="F5"
        ["F6"]="F6"
        ["F7"]="F7"
        ["F8"]="F8"
        ["F9"]="F9"
        ["F10"]="F10"
        ["F11"]="F11"
        ["F12"]="F12"
        ["G"]="G"
        ["Grave"]="Grave"
        ["H"]="H"
        ["I"]="I"
        ["J"]="J"
        ["K"]="K"
        ["L"]="L"
        ["Left"]="Left"
        ["M"]="M"
        ["N"]="N"
        ["O"]="O"
        ["P"]="P"
        ["Print"]="Print"
        ["Q"]="Q"
        ["R"]="R"
        ["Right"]="Right"
        ["S"]="S"
        ["ScrollDown"]="WheelScrollDown"
        ["ScrollUp"]="WheelScrollUp"
        ["Shift"]="Shift"
        ["Super"]="Super"
        ["T"]="T"
        ["U"]="U"
        ["Up"]="Up"
        ["V"]="V"
        ["W"]="W"
        ["X"]="X"
        ["Y"]="Y"
        ["Z"]="Z"
    )
    if [[ ${keys[$key]+exists} ]]; then
        echo "${keys[$key]}"
    else
        echo "$key"
    fi
}


configuration=$(cat "$SOURCE")

echo "binds {" > $OUTPUT
echo "binds {"

mapfile -t binding_lines < "$SOURCE"

for line in "${binding_lines[@]}"; do
    [[ $line == *=* ]] || continue

    current_word=$(parse_word "$line" 0)

    case "$current_word" in
        terminal|browser|"")
            continue
            ;;
    esac

    i=0
    bind="    "

    while true; do
        current_word=$(parse_word "$line" "$i")
        [[ -z $current_word ]] && break

        case "$current_word" in
            "+")
                bind+="+"
                ;;
            "=")
                ((++i))
                command=$(parse_word "$line" "$i")
                command=$(parse_command "$command")
                bind+="$command"
                break
                ;;
            *)
                key=$(parse_key "$current_word")
                bind+="$key"
                ;;
        esac

        ((++i))
    done

    echo "$bind" >> "$OUTPUT"
    echo "$bind"
done

echo "}" >> "$OUTPUT"
echo "}"
echo
niri validate