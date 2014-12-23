# # To-Do
# * Investigate RUBYGEMS_GEMDEPS='-' for replacing Bundler

path=("$(ruby -e 'puts Gem.user_dir')/bin" "$(npm get prefix)/bin" $path)
HISTSIZE=1000
export EDITOR='vim'
export PAGER='less -R'

autoload -Uz compinit && compinit

autoload -Uz vcs_info && precmd() { vcs_info }
zstyle ':vcs_info:*' formats '%s:%b'
zstyle ':vcs_info:*' actionformats '%s:%b (%a)'
setopt prompt_subst
PROMPT=$'<< %?\n%K{white}${(r.(($COLUMNS - ${#vcs_info_msg_0_})).)${(%):-%n@%m:%~}}$vcs_info_msg_0_%k\n>> '

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

alias git='hub'
alias gitst='git status -sb'
alias gitlg='git log --color --graph --abbrev-commit --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias gitdf='git diff --color=always'
alias gitpp='git up && git push'
alias gitmg='git merge --ff-only'
alias gitco='git checkout'

alias bootstrap='BUNDLE_PATH=.gem ~/projects/project_bootstrap/bootstrap'
setopt extendedglob
export BASE_PATH="$PATH"
chpwd() {
	export PATH="$BASE_PATH"
	unset GEM_HOME

	local project_home="$(git rev-parse --show-toplevel 2>/dev/null)"
	[ -n "$project_home" ] || return

	if [ -f "$project_home/Gemfile" ]
	then
		export GEM_HOME="$project_home/.gem"
		path=("$GEM_HOME/bin" $path)
	fi

	if [ -f "$project_home/package.json" ]
	then
		path=("$project_home/node_modules/.bin" $path)
	fi

	path=("$project_home/bin" $path)
}
chpwd
