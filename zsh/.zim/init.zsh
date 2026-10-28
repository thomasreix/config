# FILE AUTOMATICALLY GENERATED FROM /home/beglary/.config/zsh/.zimrc
# EDIT THE SOURCE FILE AND THEN RUN zimfw build. DO NOT DIRECTLY EDIT THIS FILE!

if [[ -e ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]] zimfw() { source "${HOME}/.config/zsh/.zim/zimfw.zsh" "${@}" }
fpath=("${HOME}/.config/zsh/.zim/modules/git/functions" "${HOME}/.config/zsh/.zim/modules/utility/functions" "${HOME}/.config/zsh/.zim/modules/duration-info/functions" "${HOME}/.config/zsh/.zim/modules/git-info/functions" "${HOME}/.config/zsh/.zim/modules/prompt-pwd/functions" "${HOME}/.config/zsh/.zim/modules/zsh-completions/src" "${HOME}/.config/zsh/.zim/modules/completion/functions" ${fpath})
autoload -Uz -- git-alias-lookup git-branch-current git-branch-delete-interactive git-branch-remote-tracking git-default-branch git-dir git-edit-unmerged git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw duration-info-precmd duration-info-preexec coalesce git-action git-info prompt-pwd
source "${HOME}/.config/zsh/.zim/modules/environment/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/git/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/input/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/termtitle/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/utility/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/duration-info/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/oblong/oblong.zsh-theme"
source "${HOME}/.config/zsh/.zim/modules/completion/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${HOME}/.config/zsh/.zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "${HOME}/.config/zsh/.zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh"
