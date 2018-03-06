alias ag='ag --hidden -f'
alias cp='cp -r --reflink=auto'
alias df='pydf'
alias diff='diff --color --unified'
alias dragall='dragon --and-exit --all'
alias dragon='dragon --and-exit'
alias e='nvim'
alias grep='grep --color'
alias http-serve='python3 -m http.server'
alias makepkg-compress="PKGEXT='.pkg.tar.xz' makepkg"
alias mkdir='mkdir -p'
alias o='xdg-open'
alias pacdiff='sudo \pacdiff; py3-cmd refresh "external_script pacdiff"'
alias rsync='rsync --verbose --archive --info=progress2 --human-readable --compress --partial --append-verify'
alias sudo='sudo -E '
alias vi='nvim'
alias vim='nvim'

alias m2='xrandr --output  eDP1 --auto --output DP1 --auto --above eDP1 --output DP2 --auto --right-of DP1'
alias m2hdmi='xrandr --output  eDP1 --auto --output HDMI1 --auto --left-of eDP1'
alias m1='xrandr --output DP1 --off --output DP2 --off --output HDMI1 --off'

alias m1HDMI='xrandr --output HDMI1 --off'
alias ls="exa --git --group-directories-first"
alias ll="ls -l"
alias la="ll -a"
alias lk="ll -s=size"                # Sorted by size
alias lm="ll -s=modified"            # Sorted by modified date
alias lc="ll --created -s=created"   # Sorted by created date

function mkdcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}
