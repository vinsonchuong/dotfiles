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
  local tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
  local db=$tmp/db
  local fs=$tmp/fs

  mkdir "$tmp"
  pacman -Qlq | sort -u > "$db"
  find /bin /etc /lib /sbin /usr \
    ! -name lost+found \
    \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"
  comm -23 "$fs" "$db"
  rm -rf "$tmp"
}
alias pacmd='pacman -Qii | grep "^MODIFIED" | sed "s/MODIFIED\s\+//" | sort'

transmission-cli() {
  CONF_DIR="$HOME/.config/transmission"
  echo '{"idle-seeding-limit-enabled": true, "idle-seeding-limit": 0}' > "$CONF_DIR/settings.json"
  /usr/bin/transmission-cli "$@"
  rm -rf "$CONF_DIR/resume" "$CONF_DIR/torrents"
}

alias git='hub'
alias gitst='git status -sb'
alias gitlg='git log --color --graph --abbrev-commit --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias gitdf='git diff --color=always'
alias gitpp='git up && git push'
alias gitmg='git merge --ff-only'
alias gitco='git checkout'

setopt extendedglob
export BASE_PATH="$PATH"
chpwd() {
  export PATH="$BASE_PATH"
  unset GEM_HOME

  local project_dirs; project_dirs=((../)#(.git|Gemfile)(N:a:h))
  local project_home="$project_dirs[-1]"
  if [ -n "$project_home" ]
  then
    if [ -f "$project_home/Gemfile" ]
    then
      export GEM_HOME="$project_home/.gem"
      path=("$project_home/bin" "$GEM_HOME/bin" $path)
    fi
  fi
}
chpwd
