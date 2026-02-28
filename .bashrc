#
# ~/.bashrc
#

eval "$(zoxide init bash)"
source <(fzf --bash)

if [[ "$(tty)" =~ ^/dev/tty[1-6]$ ]]; then
setfont ter-132n
setterm -blength 0
	if [[ ! -f ~/.wifi_done ]]; then
	nmtui
	fi
	touch ~/.wifi_done
#btop -t -u 100
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#### main ####

alias gr='grep -R -I --exclude-dir={.cache,firefox}'
alias cmp='grep -Fx -f'

alias p='ping 1.1.1.1'

alias vam='vim $(fzf --preview="bat --color=always {}")'
alias v='vim'
alias vm='vim'

alias f='fzf --preview="bat --color=always {}" --preview-window="right,75%,border-left,<80(up,70%,border-bottom)"'
alias f2='fd --full-path --type f /etc /usr /usr/local /home /var | fzf'
alias bt='systemctl start bluetooth'
alias btc='bluetoothctl'

alias stw='stow --no-folding --adopt . && git restore .'
alias count='i=0; while true; do printf "\r%d" "$i"; ((i++)); sleep 1; done'

#### flatpak ####

alias fis='flatpak install'
alias fup='flatpak update'

#### pacman ####

alias up='echo "" && echo "PACMAN pkgs" && sudo pacman -Syu --ignore linux && echo "" && echo "" && echo "FLATPAK pkgs" && flatpak update'
alias is='sudo pacman -S --needed'
alias qu='sudo pacman -Qu'
alias cu='checkupdates'
alias ss='sudo pacman -Ss'
alias pr='sudo pacman -R'
alias qs='sudo pacman -Qs'
alias ql='sudo pacman -Ql'
alias qi='sudo pacman -Qi'
alias si='sudo pacman -Si'
alias qe='sudo pacman -Qe'
alias qo='sudo pacman -Qo'
alias qqe='sudo pacman -Qqe'

#### git ####

alias gy='cd && git clone https://aur.archlinux.org/yay ; cd yay ; makepkg -si'
alias gp='cd && git clone https://aur.archlinux.org/paru ; cd paru ; makepkg -si'
alias gc='printf "name/name\nREPONAME: " && read -rp "" REPO  && git clone https://github.com/$REPO'
alias push='git add . && git commit -m "." && git push'
alias pp='cd ~/lol && git add . && git commit -m "." && git push'
alias ga='git add . && git commit -m "."'
alias ppg='cd ~/lol && git push gitlab main'
alias gra='git remote add gitlab https://gitlab.com/instantuzer/install.git'
alias gst='git status'
alias gs='cd ~/lol && git show --name-only'
alias gb='git blame --color-lines $(fzf)'
alias gch='cd ~/lol & git log -p -U0 --no-prefix'
alias god='git log -p  --unified=0 | grep -E '^-' | bat'
alias gn='gh repo create --private --source=. --remote=origin'
alias gl='git log -p --follow --'

alias resto='git restore .'
alias sto='stow --adopt --no-folding .'

alias cb='cat ~/.bashrc | grep'
alias key='cat ~/.config/i3/config | grep'
alias wk='~/.config/i3/wttr3'
alias vd='vimdiff'

alias lak='sudo cryptsetup luksAddKey'
alias lrk='sudo cryptsetup luksRemoveKey'
alias cs='sudo cryptsetup'
alias cso='sudo cryptsetup luksOpen'

alias treee='tree -a -I .git'
alias ls='eza -la'
alias cl='read -rp "FILENAME: " CLIP && cat $CLIP | xclip -selection clipboard'
alias hi='history'
alias hig='history | grep'
alias se="sudoedit"
alias ff='fastfetch'
alias b='btop -t -u 100'
alias m='tmux'
alias conf='vim ~/.config/i3/config'
alias confbak='vim ~/.config/i3/bakconfig'
alias conf2='vim ~/.config/hypr/hyprland.conf'
alias c='startx'
alias s='sway'
alias h='hyprland'
alias t='echo '' && date && echo '' && cal -m'
alias zl='unzip -l'
alias tl='tar -tvf'

alias wp='feh --bg-scale'
alias mg='magick -verbose'

alias sshd='systemctl start sshd'

alias dns='~/script/dns'
alias sus='systemctl suspend'
alias wifi='rfkill list'

alias dl='cd ~/Downloads && eza -la'
alias zl='cd ~ && eza -la'
alias sl='cd ~/lol/script && eza -la'
alias ll='cd ~/lol && eza -la'

alias y='yazi'
alias py='python'
alias yt='yt-dlp'

alias cls='clear'
alias clr='clear'

alias bsh='vim ~/.bashrc'
alias sobash='source ~/.bashrc'

#alias ipkg='grep -v '^\s*#' < read -rp "pkgname:" pkgsfile && cat pkgsfile | sudo pacman -S --needed --noconfirm -'
alias ipkg='bash -c '\''read -rp "Package list file: " pkgsfile; grep -v "^[[:space:]]*#" "$pkgsfile" | sudo pacman -S --noconfirm --needed -'\'''
alias pkgs2='grep -v '^\s*#' pkgs2 | sudo pacman -S --noconfirm --needed -'

#PS1="\u@\h \$ "
#PS1=' $(date +"%T") \$ '
#PS1='\[\e[38;5;214m\] $(date +"%T") \$ \[\e[0m\]'
t
PS1='\n$( [[ -n "$SSH_CONNECTION" ]] && echo "$(hostname -i)" )\[\e[38;5;214m\]$PWD 😺  '

grdns() {
    if [ -z "$1" ]; then
        echo "Available connections:"
        nmcli -t -f NAME connection show
        echo
        echo "Usage: dnscon \"connection name\""
        return 1
    fi

    if ! nmcli -t -f NAME connection show | grep -Fxq "$1"; then
        echo "Error: Connection '$1' not found."
        echo
        echo "Available connections:"
        nmcli -t -f NAME connection show
        return 1
    fi

    echo "DNS for connection: $1"
    nmcli connection show "$1" | grep DNS
}

sshtv() {
    read -p "user: " USR
    ssh "$USR@192.168.178.20"
}

ddsda() {
    echo ""
    lsblk
    read -p "sda (y/N)?" confirm
    if [[ "$confirm" == "y" ]]; then
        sudo dd if=~/Downloads/archlinux-x86_64.iso of=/dev/sda bs=8M status=progress conv=fdatasync
    else
        echo "Aborted."
    fi
}

rf() {
    mapfile -t DEVICES < <(rfkill --output ID,TYPE,SOFT,HARD --noheadings | awk '{print $1 ":" $2}')

    if [ ${#DEVICES[@]} -eq 0 ]; then
        echo "No rfkill devices found."
        return 1
    fi

    echo "Available wireless devices:"
    for i in "${!DEVICES[@]}"; do
        ID=$(echo "${DEVICES[$i]}" | cut -d: -f1)
        TYPE=$(echo "${DEVICES[$i]}" | cut -d: -f2)
        echo "[$i] ID=$ID  TYPE=$TYPE"
    done

    echo
    read -p "Select device number: " CHOICE

    if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -ge "${#DEVICES[@]}" ]; then
        echo "Invalid selection."
        return 1
    fi

    ID=$(echo "${DEVICES[$CHOICE]}" | cut -d: -f1)

    echo
    echo "Choose action:"
    echo "1) block"
    echo "2) unblock"
    echo "3) toggle"
    read -p "Select action: " ACTION

    case "$ACTION" in
        1)
            sudo rfkill block "$ID"
            ;;
        2)
            sudo rfkill unblock "$ID"
            ;;
        3)
            if rfkill list "$ID" | grep -q "Soft blocked: yes"; then
                sudo rfkill unblock "$ID"
            else
                sudo rfkill block "$ID"
            fi
            ;;
        *)
            echo "Invalid action."
            return 1
            ;;
    esac

    echo
    rfkill list "$ID"
}
