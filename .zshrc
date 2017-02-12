alias ls='ls -hF --color=auto'
alias lsa='ls -a'
alias lsl='ls -l'
alias lsla='ls -al'
alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -pv'
alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias df='di'
alias du='du -ch'
alias grep='grep --color=auto'
alias diff='colordiff -u'
alias ping='ping -c 5'

open() {
	i3-msg exec "xdg-open '$(realpath "$1")'" > /dev/null
}

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
	sudo aura -Ayua --devel
	paccl
}
alias aurin='sudo aura -Aya'
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

hub() {
	GITHUB_TOKEN="$(pass github | head -2 | tail -1)" command hub "$@"
}
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

alias virsh='virsh -c qemu:///system'
alias virt-install='virt-install --connect qemu:///system'
alias virt-viewer='virt-viewer -c qemu:///system'

prototypical() {
	GEM_HOME='.gem' \
	JSPM_GITHUB_AUTH_TOKEN="$(echo "$(pass github | awk '$1 == "Username:" {print $2}'):$(pass github | head -2 | tail -1)" | tr -d '\n' | base64)" \
		command prototypical "$@"
}

jspm() {
	JSPM_GITHUB_AUTH_TOKEN="$(echo "$(pass github | awk '$1 == "Username:" {print $2}'):$(pass github | head -2 | tail -1)" | tr -d '\n' | base64)" \
		command jspm "$@"
}

path=("$HOME/bin" "$(ruby -e 'puts Gem.user_dir')/bin" "$(npm get prefix)/bin" $path)
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
source ~/.fzf.zsh

chpwd() {
	export PATH="$BASE_PATH"
	unset PROJECT_HOME PROJECT_RUBY PROJECT_NODE
	unset GEM_HOME

	local project_home="$(git rev-parse --show-toplevel 2>/dev/null)"
	[ -n "$project_home" ] || return

	if [ -f "$project_home/Gemfile" ]
	then
		export PROJECT_RUBY='yes'
		export GEM_HOME="$project_home/.gem"
		path=("$GEM_HOME/bin" $path)
	fi

	if [ -f "$project_home/package.json" ]
	then
		export PROJECT_NODE='yes'
		path=("$project_home/node_modules/.bin" $path)
	fi

	export PROJECT_HOME="$project_home"
	path=("$project_home/bin" $path)
}
chpwd
