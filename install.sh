#! /bin/zsh
if [ ! -d ${HOME}/.zsh ]; then
  if [ ! -d ${HOME}/.zprezto ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/z*; do
      farray=(`echo $rcfile | tr -s '/' ' '`)
      rcfname=${farray[${#farray[@]} - 1]}
      if [ ! ${rcfname} = "zshrc" ]; then
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        # echo ${rcfname}
      fi
    done
  fi
  git clone https://github.com/TNaky/zshrc.git ${HOME}/.zsh
  ln -s ${HOME}/.zsh/zshrc ${HOME}/.zshrc
  ln -s ${HOME}/.zsh/zsh_aliases ${HOME}/.zsh_aliases
fi
