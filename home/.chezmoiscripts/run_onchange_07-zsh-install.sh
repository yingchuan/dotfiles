#!/bin/bash
sudo_cmd="sudo"

[ "$(basename ${SHELL})" != "zsh" ] && $sudo_cmd chsh -s $(which zsh) $(id -un)

exit 0

