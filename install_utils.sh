#!/bin/bash

# install neovim and tmux
apt-get update && apt-get install -y software-properties-common tmux
add-apt-repository -y ppa:neovim-ppa/stable && apt-get update && apt-get install -y neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install node and yarn for coc
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
echo "alias vim='nvim'" >> ~/.bashrc

# copy nvim init file
mkdir -p ~/.config/nvim && cp ./init.vim ~/.config/nvim/init.vim
tic ./xterm-256color-italic.terminfo
echo "TERM=xterm-256color-italic" >> ~/.bashrc
cp ./coc-settings.json ~/.config/nvim/coc-settings.json
pip3 install --upgrade "jedi>=0.17"

while getopts cpj flag
do
    case "${flag}" in 
        c) cpp=true;;
        p) python=true;;
        j) js=true;;
    esac
done


if [ $cpp ]; then
	# install clang toolchain, ccls and configure coc
	wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
	apt-add-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-10 main"
  apt-get install -y libllvm-10-ocaml-dev libllvm10 llvm-10 llvm-10-dev llvm-10-doc llvm-10-examples llvm-10-runtime
  apt-get install -y clang-10 clang-tools-10 clang-10-doc libclang-common-10-dev libclang-10-dev libclang1-10 clang-format-10 python3-clang-10 clangd-10 
  git clone --depth=1 --recursive https://github.com/MaskRay/ccls && cd ccls && \
  cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/lib/llvm-10 && \
  cmake --build Release --target install && cd .. && rm -r -f ccls
	echo "cpp: ${cpp}"
fi

