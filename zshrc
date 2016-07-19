#! /bin/zsh
# OS別の処理
OS=''
if [[ "$(uname)" == 'Darwin' ]]; then
  OS='mac'
elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
  OS='linux'
elif [[ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]]; then
  OS='cygwin'
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# ビープ音を鳴らさない
setopt no_beep
# Vi mode
bindkey -v
function zle-line-init zle-keymap-select {
  # VIM_NORMAL="%K{148}%F%k%f%K{148}%F{022} %B NORMAL %b%k%f%K{black}%F{148}⮀%k%f"
  # VIM_INSERT="%K{255}%F%k%f%K{255}%F{024} %B INSERT %b%k%f%K{black}%F{255}⮀%k%f"
  VIM_NORMAL="-- %F{022}NORMAL%f --"
  VIM_INSERT="-- %F{024}INSERT%f --"
  RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
  RPS2=$RPS1
  zle reset-prompt
}

# 履歴関連
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^R" history-incremental-pattern-search-backward
# Zsh特有の移動を設定
bindkey -a "^A" vi-beginning-of-line
bindkey -a "^E" vi-end-of-line
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
# Normal modeへの遷移時間
export KEYTIMEOUT=1
# Normal mode時にvでvimを起動
export VISUAL=vim
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# export Android development
export ANDROID_SDK=${HOME}/Library/android-sdk-macosx
# export ANDROID_NDK=${HOME}/Library/android-ndk-r10e
export ANDROID_NDK=${HOME}/Library/android-ndk-r9d

## Customize to your needs...
export WWW_HOME="google.co.jp"

# less 関連の環境変数
## -j10 検索結果が上から１０行目に来る
## --no-init less終了後も表示内容が残る
## --quit-if-one-screen 画面に収まりきる表示量であれば終了する
## --RAW-CONTROL-CHARS カラーコードを適切に処理
export LESS='-j10 --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
if [[ $OS = 'mac' ]]; then
  ## source-highlightと同梱されてるカラースキーマまでのパス
  ## src-hilite-lesspipe.shはソースをVim等のエディタみたいにハイライトしてくれるスクリプト
  export LESSOPEN='| src-hilite-lesspipe.sh %s'
fi

# 環境変数(PATH)
## tmux起動によって２重に読み込まれることが内容にするため
if [[ -z $TMUX ]]; then
  export XDG_CONFIG_HOME=~/.config
  export PATH=${PATH}:/Applications/CMake.app/Contents/bin
  # export homeBin
  export PATH=${PATH}:${HOME}/.bin/sh
  # export Android development
  export PATH=${PATH}:${ANDROID_SDK}/platform-tools
  export PATH=${PATH}:${ANDROID_SDK}/tools
  export PATH=${PATH}:${ANDROID_NDK}
  export ANDROID_ABI='armeabi-v7a'
  # nodebrew
  export PATH=${PATH}:${HOME}/.nodebrew/current/bin
fi

# macの場合brwe caskのインストール先ディレクトリを指定
if [[ $OS == 'mac' ]]; then
  mkdir -p ${HOME}/Applications/homebrew-cask
  export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications/homebrew-cask"
fi

# login時にtmuxを起動
if [[ -z "$TMUX" && -z "$WINDOW" && ! -z "$PS1" ]]; then
  if $(tmux has-session 2> /dev/null); then
    tmux attach -d
  else
    tmux
  fi
fi

# exitの処理をtmuxログインの是非によって分岐
# exit() {
#   if [[ -z $TMUX ]]; then
#     builtin exit
#   else 
#     tmux detach
#   fi
# }


# ssh接続時のtmuxウィンドウ名を接続先の名前で表示
function ssh() {
  if [[ -n $(printenv TMUX) ]]; then
    local window_name=$(tmux display -p '#{window_name}')
    tmux rename-window -- "$@[-1]"
    command ssh Michibata.at.Chloe tmux set-option status off
    command ssh $@
    tmux rename-window $window_name
  else
    command ssh $@
  fi
}

if [ -f ~/.zsh_aliases ]; then
  . ~/.zsh_aliases
else
  echo "#! /bin/zsh\n" >> .zsh_aliases
fi

# function jpm {
  # jpm -b /Applications/FirefoxDeveloperEdition.app/Contents/MacOS/firefox-bin $1
# }
