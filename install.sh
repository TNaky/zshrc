#! /bin/zsh
if [ ! -d ${HOME}/.zsh ]; then
  if [ ! -d ${HOME}/.zprezto ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/z*; do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
  fi
  git clone https://github.com/TNaky/zshrc.git ${HOME}/.zsh
  ln -s ${HOME}/.zsh/zshrc ${HOME}/.zshrc
  ln -s ${HOME}/.zsh/zsh_aliases ${HOME}/.zsh_aliases
fi
