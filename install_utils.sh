#!/bin/bash
while getopts c:p:j: flag
do
    case "${flag}" in 
        c) cpp=true;;
        p) python=true;;
        j) js=true;;
    esac
done
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "cpp: ${cpp}"
echo "python: ${python}"
echo "js: ${js}"

