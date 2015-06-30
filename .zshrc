# # To-Do
# * Investigate RUBYGEMS_GEMDEPS='-' for replacing Bundler
function contains() {
	local element
	for element in "${@:2}"
	do
		if [[ "$element" == "$1" ]]
		then
			return 0
		fi
	done
	return 1
}

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

function git() {
	if contains "$1" 'pull-request' 'fork' 'create' 'release' 'issue'
	then
		local credentials="$(pass github)"
		cat <<-EOF > "$HOME/.config/hub"
		github.com:
		- user: $(echo "$credentials" | awk '/Username/ {print $2}')
		  oauth_token: $(echo "$credentials" | awk 'NR == 2')
		  protocol: https
		EOF
	fi
	hub "$@"
	local code=$?
	echo '' > "$HOME/.config/hub"
	return $code
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
		local description="$(jq '.description' package.json)"
		local homepage="$(jq '.homepage' package.json)"
	fi
	git create -d "$description" -h "$homepage"
	git push --set-upstream origin master
}
gitcg() {
	gitdf "$(git tag | sort -V | tail -1)"
}

gitaur-deploy() {
	/usr/bin/gitaur-deploy -u 'vinsonchuong' -p "$(pass archlinux | head -1)" "$@"
}

npm() {
	cat "$(dirname "$(readlink "$HOME/.zshrc")")/.npmrc" > "/tmp/$(whoami)/.npmrc"
	if contains "$1" 'publish'
	then
		local credentials="$(pass npm)"
		cat <<-EOF | command npm login
		$(echo "$credentials" | awk '/Username/ {print $2}')
		$(echo "$credentials" | head -1)
		$(echo "$credentials" | awk '/Email/ {print $2}')
		EOF
		command npm "$@"
		local code=$?
		command npm logout
	else
		command npm "$@"
		local code=$?
	fi
	echo '' > "/tmp/$(whoami)/.npmrc"
	return $code
}

travis() {
	if contains "$1" accounts cache cancel disable enable encrypt-file env init \
		raw repos restart settings setup token whatsup whoami
	then
		command travis login --github-token "$(pass github | awk 'NR == 2')"
		command travis "$@"
		local code=$?
		command travis logout
		return $code
	else
		command travis "$@"
	fi
}

alias virsh='virsh -c qemu:///system'
alias virt-install='virt-install --connect qemu:///system'
alias virt-viewer='virt-viewer -c qemu:///system'

alias bootstrap='~/projects/project_bootstrap/bootstrap'

path=("$(ruby -e 'puts Gem.user_dir')/bin" "$(npm get prefix)/bin" "$HOME/bin" $path)
HISTSIZE=1000
export EDITOR='vim'
export PAGER='less -R'
export BASE_PATH="$PATH"
export BUNDLE_PATH='.gem'
setopt extendedglob

autoload -Uz compinit && compinit

autoload -Uz vcs_info && precmd() { vcs_info }
zstyle ':vcs_info:*' formats '%s:%b'
zstyle ':vcs_info:*' actionformats '%s:%b (%a)'
setopt prompt_subst
PROMPT=$'<< %?\n%K{white}${(r.(($COLUMNS - ${#vcs_info_msg_0_})).)${(%):-%n@%m:%~}}$vcs_info_msg_0_%k\n>> '

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
