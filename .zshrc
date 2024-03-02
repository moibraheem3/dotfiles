export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="spaceship"
eval "$(starship init zsh)"

plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# alias vim="~/.local/bin/lvim"
alias vim="nvim"
alias lg="lazygit"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/mohamed/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Created by `userpath` on 2023-10-28 11:35:40
export PATH="$PATH:/home/mohamed/.local/bin"
# go
GOBIN="/usr/local/go/bin"
export GOPATH="/home/mohamed/go"
export PATH="$PATH:$GOBIN:$GOPATH/bin"

export EDITOR="nvim"
