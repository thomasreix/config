push() {
    git add . &&
    git commit -m "update" &&
    git push
}

binds() {
	micro ~/.config/binds &&
	~/.config/niri/config.sh
}
