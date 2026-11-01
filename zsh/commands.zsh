push() {
    git add . &&
    git commit -m "update" &&
    git push
}

binds() {
	micro ~/.config/binds &&
	~/.config/niri/config.sh
}

c() {
    local file="$1"
    local output="${file##*/}"
    output="${output%.c}"

    shift

    while (($#)); do
        case "$1" in
            -o)
                output="$2"
                shift 2
                ;;
            *)
                echo "Unknown argument: $1"
                return 1
                ;;
        esac
    done

    if grep -q 'raylib.h' "$file"; then
        cc "$file" -o "$output" $(pkg-config --cflags --libs raylib) || return
    else
        cc "$file" -o "$output" || return
    fi

    "./$output"
}

cf() {
    local style="file:${XDG_CONFIG_HOME:-$HOME/.config}/clang-format"
    local -a files

    if (($#)); then
        clang-format --style="$style" -i -- "$@"
        return
    fi

    files=( *.c(N) *.h(N) )

    if ((${#files[@]} == 0)); then
        print -u2 "No C files found"
        return 1
    fi

    clang-format --style="$style" -i -- "${files[@]}"
}
