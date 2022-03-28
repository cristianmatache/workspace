# ls 
eval $( dircolors -b ~/LS_COLORS )


# PS1
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# export PS1="\[\033[38;5;9m\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\h \[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(tput sgr0)\]\033[38;5;10m\]\$(parse_git_branch)\[\033[00m\]"$'\n$ '
export PS1="\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\h \[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(tput sgr0)\]\033[38;5;10m\$(parse_git_branch)\[\033[00m\]"$'\n$ '


# grep
alias grep="grep --color=auto"
export GREP_COLOR='1;32'


# top = tasklist
alias top="tasklist"

# q
alias q="q -p 5000 -U /c/q/credentials.txt"

# PATH
export PATH=/d/Anaconda3/Scripts/:$PATH
export PATH=/d/Anaconda3/:$PATH
export PATH=/c/q/w64/:$PATH
export PATH=/d/workspace/apps/bazel/:$PATH
export PATH=/d/workspace/apps/haskell/:$PATH
export PATH=/c/Users/Cristian\ Matache/AppData/Roaming/cabal/bin:$PATH
export PATH=/c/ProgramData/chocolatey/lib/ghc/tools/ghc-8.10.1/bin:$PATH
export PATH=/C/tools/msys64:$PATH
export PATH=~/AppData/Roaming/cabal/store/ghc-8.10.1/hlint-3.1.6-1b3140bfaf96308deb8b83d420de5ca73f3273b2/bin:$PATH

# PYTHONPATH
export PYTHONPATH=~/Desktop/param-tuning/autotune
export PYTHONPATH=~/Desktop/autotune-combined
export PYTHONPATH=~/Desktop/reclone-2/param-tuning/autotune
export MYPYPATH=/d/workspace/python/src/autotune-v3/autotune

# cd
alias cdautotune="cd ~/Desktop/param-tuning/autotune"
alias cdautotune3="cd /d/workspace/python/src/autotune-v3/"

