export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

alias ls='exa'
alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -pv'
alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias df='duf'
alias du='du -ch'
alias grep='grep --color=auto'
alias diff='colordiff -u'
alias ping='ping -c 5'

paccl() {
	sudo aura -Oj
	sudo paccache -r
	sudo paccache -ruk0
}
pacup() {
	sudo aura -Syyu
	paccl
}
alias pacin='sudo aura -Sy'
alias pacun='sudo aura -Rcns'
aurup() {
	sudo aura -Auax --devel --force "$@"
	paccl
}
alias aurin='sudo aura -Aax --hotedit'
alias aurun='pacun'
pacds() {
	local tmp=$(mktemp -d)
	pacman -Qlq | sort -u > $tmp/db
	find /bin /etc /lib /sbin /usr \
		! -name lost+found \( -type d -printf '%p/\n' -o -print \) \
		| sort > $tmp/fs
	comm -23 $tmp/fs $tmp/db
	rm -rf $tmp
}
alias pacmd='pacman -Qii | grep "^MODIFIED" | sed "s/MODIFIED\s\+//" | sort'

alias gitst='git status -sb'
alias gitlg='git log --color --graph --abbrev-commit --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias gitdf='git diff --color=always'
alias gitpp='git up && git push && git push --tags'
alias gitmg='git merge --ff-only'
alias gitco='git checkout'
alias gitcm='git commit -v'
gitcr() {
	if [ "$PROJECT_NODE" = 'yes' ]
	then
		local description="$(jq -r '.description' package.json)"
		local homepage="$(jq -r '.homepage' package.json)"
	fi

	if [[ -n $description && -n $homepage ]]
	then
		hub create -d "$description" -h "$homepage" "$@"
	elif [[ -n $description ]]
	then
		hub create -d "$description" "$@"
	elif [[ -n $homepage ]]
	then
		hub create -d "$homepage" "$@"
	else
		hub create "$@"
	fi

	git push --set-upstream origin master
}
gitcg() {
	gitdf "$(git tag | sort -V | tail -1)"
}
gitpb() {
	local version

	if [[ $PROJECT_NODE ]]
	then
		version="v$(jq -r '.version' package.json)"
		gitcm -m "$version"
		git tag "$version"
		gitpp
	fi
}

path=(
	"$HOME/bin"
	"$(yarn global bin)"
	"$(python -c 'import site; print(site.USER_BASE)')/bin"
	$path
)
HISTSIZE=1000
export EDITOR='nvim'
export PAGER='less -R'
export BASE_PATH="$PATH"
setopt extendedglob

autoload -Uz compinit && compinit

autoload -Uz vcs_info && precmd() { vcs_info }
zstyle ':vcs_info:*' formats '%s:%b'
zstyle ':vcs_info:*' actionformats '%s:%b (%a)'
setopt prompt_subst
PROMPT=$'<< %?\n%K{white}${(r.(($COLUMNS - ${#vcs_info_msg_0_})).)${(%):-%n@%m:%~}}$vcs_info_msg_0_%k\n>> '

compdef "_files -/ -W '$HOME/projects'" 'project'
compdef "_files -/ -W '$HOME/virtualization'" 'vm'

chpwd() {
	export PATH="$BASE_PATH"
	unset PROJECT_HOME PROJECT_NODE

	local project_home="$(git rev-parse --show-toplevel 2>/dev/null)"
	[ -n "$project_home" ] || return

	if [ -f "$project_home/package.json" ]
	then
		export PROJECT_NODE='yes'
		path=("$project_home/node_modules/.bin" $path)
	fi

	if [ -f "$project_home/.env" ]
	then
		source "$project_home/.env"
	fi

	export PROJECT_HOME="$project_home"
	path=("$project_home/bin" $path)
}
chpwd
