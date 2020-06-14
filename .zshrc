# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/tninomiya/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall
prompt spaceship

setopt auto_list
setopt auto_menu
setopt HIST_IGNORE_DUPS
zstyle ':completion:*:default' menu select=1

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
setopt correct

export GOPATH='/home/tninomiya/go'
export PATH="${GOPATH}/bin:$PATH"
export PATH="${HOME}/.cargo/bin:$PATH"

# spaceship prompt
SPACESHIP_GOLANG_SHOW=true
SPACESHIP_GOLANG_SYMBOL=$'\ue626'


# init zplug
if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
fi
source ~/.zplug/init.zsh

# plugin list
# zplug "user/repo", tag
zplug "zsh-users/zsh-completions"
zplug "peterhurford/git-aliases.zsh"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

# manage zplug as plugin
zplug "zplug/zplug", hook-build:'zplug --self-manage'

# install unmanged plugins
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# load plugins
zplug load –verbose

export $(dbus-launch)
fpath=($HOME/.zsh/anyframe(N-/) $fpath)
autoload -Uz anyframe-init
anyframe-init

## よく移動するディレクトリ一覧をインクリメントサーチ & 移動
bindkey '^@' anyframe-widget-cdr
## bash history一覧インクリメントサーチ & 実行
bindkey '^r' anyframe-widget-execute-history
## branch一覧をインクリメントサーチ & checkout
bindkey '^b' anyframe-widget-checkout-git-branch
## プロセス一覧をインクリメントサーチ & kill
bindkey '^xk' anyframe-widget-kill
## ghqでcloneしたリポジトリ一覧をインクリメントサーチ
bindkey '^g' anyframe-widget-cd-ghq-repository

autoload -U +X compinit && compinit

function peco-ssh () {
  local selected_host=$(awk '
  tolower($1)=="host" {
    for (i=2; i<=NF; i++) {
      if ($i !~ "[*?]") {
        print $i
      }
    }
  }
  ' ~/.ssh/config | sort | peco --query "$LBUFFER")
  if [ -n "$selected_host" ]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ssh
bindkey '^h' peco-ssh


source ~/.zprofile
source <(kubectl completion zsh)
