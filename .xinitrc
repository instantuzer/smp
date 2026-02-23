#xrandr --output HDMI1 --mode 1920x1080
#xrandr --output HDMI1 --mode 1920x1080 --right-of eDP1
#xrandr --output HDMI1 --same-as eDP1
#export SUDO_EDITOR=vim
#export EDITOR=vim
#export VISUAL=vim
#export TERMINAL=alacritty
#export BROWSER=firefox
#export GTK_THEME=Adwaita:dark
#export GTK_ICON_THEME=Papirus-Dark
#export XDG_CURRENT_DESKTOP=i3
#export XDG_SESSION_DESKTOP=i3
#export XDG_SESSION_TYPE=x11
#setxkbmap -option caps:escape_shifted_capslock

if [ -f ~/.xprofile ]; then
    . ~/.xprofile
fi

xsetroot -solid "#0c0c0c"
xset b off
exec i3
