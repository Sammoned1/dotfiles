if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
zoxide init fish | source
set -gx EDITOR /usr/bin/nvim
set -gx XDG_CONFIG_HOME /home/sammoned/.config
set -gx PATH $PATH /home/sammoned/.cargo/bin
