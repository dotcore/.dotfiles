# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# history setup
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify


source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/.bin/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ----- Bat (better cat) -----

export BAT_THEME=tokyonight_night

# ---- Eza (better ls) -----

alias ls="eza --icons=always"

# ---- TheFuck -----

# thefuck alias
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

alias cd="z"

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi


# Auto-completion
[[ $commands[fzf] ]] && source <(fzf --zsh)
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
[[ $commands[kubecm] ]] && source <(kubecm completion zsh)
[[ $commands[stern] ]] && source <(stern --completion zsh)
[[ $commands[terraform] ]] && complete -C /opt/homebrew/bin/terraform terraform

# Add aliases for nvim
alias vim="nvim"
alias vi="nvim"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

alias screen='screen -c ~/.config/screen/screenrc'

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

autoload -U +X bashcompinit && bashcompinit

function code() {
    INSULTS=(
        "Oh, so you think you're a developer? Pathetic. Use nvim like a real programmer!"
        "VS Code? Really? Might as well give up and use Notepad, you amateur."
        "If your code is as lazy as your editor choice, it's no wonder you're struggling."
        "Are you trying to embarrass yourself? Use nvim and maybe you'll gain some respect."
        "What are you doing with 'code'? Did you forget how to be a real coder?"
        "Imagine thinking 'code' is a legitimate editor. How tragic."
        "Is this some kind of joke? Grow up and use nvim."
        "Every time you use 'code,' a real developer cringes. Stop it."
        "I didn't realize I was dealing with such a noob. Use nvim, if you can handle it."
        "Why don't you just use Microsoft Word at this point? Pathetic."
    )

    while true; do
        RANDOM_INSULT=${INSULTS[RANDOM % ${#INSULTS[@]}]}
        if [[ -n $RANDOM_INSULT ]]; then
            echo $RANDOM_INSULT
            break
        fi
    done
}

# Function to insult you for using 'yarn' instead of 'pnpm'
function yarn() {
    # Array of insulting remarks
    INSULTS=(
        "Yarn? Really? You must enjoy wasting time. Use pnpm and save some dignity."
        "Still using yarn? I thought you knew better. pnpm is what real developers use."
        "Every time you use yarn, somewhere a programmer dies a little inside. Use pnpm."
        "Yarn? Are you stuck in the past? Join the present with pnpm."
        "Oh great, another yarn user. When will you learn to use pnpm?"
        "Using yarn, are we? I guess some people never learn. Use pnpm!"
        "Yarn is for amateurs. Switch to pnpm if you want to be taken seriously."
        "If you're using yarn, you might as well be coding with crayons. Use pnpm."
        "Seriously, yarn? That's almost as bad as npm. Use pnpm and upgrade your life."
        "You want to use yarn? Fine, but don't say I didn't warn you. pnpm is the future."
    )

    # Select a random insult from the array
    RANDOM_INSULT=${INSULTS[RANDOM % ${#INSULTS[@]}]}

    # Print the insult
    echo $RANDOM_INSULT

    # Prompt the user to type "I am stupid" to proceed
    echo -n "If you really want to use yarn, type 'I am stupid' and press Enter: "
    read CONFIRMATION

    # Check if the user typed the correct phrase
    if [[ "$CONFIRMATION" == "I am stupid" ]]; then
        command yarn "$@"
    else
        echo "Smart choice. Now go use pnpm like a real developer."
    fi
}

