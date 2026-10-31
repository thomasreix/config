#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config"
SOURCE="$CONFIG/binds"
OUTPUT="$CONFIG/niri/binds2.kdl"

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

function parse_bind() {
    local configuration=$1
    local objective=$2

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
        ["E"]="E"
        ["Enter"]="Return"
        ["F"]="F"
        ["G"]="G"
        ["Grave"]="Grave"
        ["H"]="H"
        ["I"]="I"
        ["J"]="J"
        ["K"]="K"
        ["L"]="L"
        ["M"]="M"
        ["N"]="N"
        ["O"]="O"
        ["P"]="P"
        ["Q"]="Q"
        ["R"]="R"
        ["S"]="S"
        ["Shift"]="Shift"
        ["Super"]="Super"
        ["T"]="T"
        ["U"]="U"
        ["V"]="V"
        ["W"]="W"
        ["X"]="X"
        ["Y"]="Y"
        ["Z"]="Z"
    )
    local i=0
    local current_word
    local position=0
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

configuration=$(cat "$SOURCE")

terminal=$(parse_value "$configuration" "terminal")
browser=$(parse_value "$configuration" "browser")
minecraft=$(parse_value "$configuration" "minecraft")

echo "$terminal"
echo "$browser"
echo "$minecraft"

echo $(parse_word "$configuration" 13)


echo "binds {" > $OUTPUT