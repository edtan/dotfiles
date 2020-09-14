#!/bin/bash

# https://wiki.archlinux.org/index.php/PC_speaker
sudo rmmod pcspkr
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

sudo pacman -Syu

sudo pacman -S \
  fzf \
  graphviz \
  python-graphviz \
  gvim \
  tree \
  xclip

# install vim plugins
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
git clone https://github.com/mbbill/undotree.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/tpope/vim-commentary.git
git clone https://github.com/tpope/vim-surround.git

# setup git
git config --global user.name "Ed Tan"
git config --global user.email edtan@users.noreply.github.com
git config merge.tool vimdiff
git config merge.conflictstyle diff3
git config mergetool.prompt false
git config --global core.editor "vim"
git config --global mergetool.keepBackup false

# https://junegunn.kr/2016/07/fzf-git/
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
git clone git@github.com:edtan/dotfiles.git
sudo cp dotfiles/fzf-git/* /usr/share/fzf/


# source fzf scripts
# https://wiki.archlinux.org/index.php/Fzf
echo 'source /usr/share/fzf/key-bindings.bash' >> ~/.bashrc
echo 'source /usr/share/fzf/completion.bash' >> ~/.bashrc
echo 'source /usr/share/fzf/git-functions.bash' >> ~/.bashrc
echo 'source /usr/share/fzf/git-key-bindings.bash' >> ~/.bashrc

# https://wiki.archlinux.org/index.php/SSH_keys#Start_ssh-agent_with_systemd_user
cat << 'EOF' >> ~/.bashrc
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
EOF
