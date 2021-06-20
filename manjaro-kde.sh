#!/bin/bash

# https://wiki.archlinux.org/index.php/PC_speaker
sudo rmmod pcspkr
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

sudo pacman -Syu

sudo pacman -S \
  aws-cli \
  clang \
  cpio \
  cmake \
  code \
  docker \
  docker-compose \
  efibootmgr \
  flake8 \
  freerdp \
  fzf \
  geckodriver \
  go \
  gvim \
  graphviz \
  jdk8-openjdk \
  jq \
  helm \
  keepassxc \
  kubectl \
  nvm \
  packer \
  python-black \
  python-graphviz \
  python-language-server \
  python-isort \
  signal-desktop \
  strace \
  terraform \
  tree \
  ttf-ms-fonts \
  unzip  \
  vagrant \
  vault \
  virtualbox \
  virtualbox-host-dkms \
  wireshark-qt \
  xclip

curl -L https://github.com/nektos/act/releases/download/v0.2.18/act_Linux_x86_64.tar.gz -o act.tar.gz
TMP_INSTALL_DIR='/tmp/act-install'
mkdir "$TMP_INSTALL_DIR"
tar xzf act.tar.gz -C "$TMP_INSTALL_DIR"
sudo mv "$TMP_INSTALL_DIR/act" /usr/local/bin/act
sudo rm -rf "$TMP_INSTALL_DIR"
rm act.tar.gz

# github.com/moby/mob/issues/38373
sudo systemctl enable docker.socket
sudo systemctl start docker.socket
sudo usermod -aG docker $USER

echo "alias k='kubectl'" >> ~/.bashrc

echo 'source /usr/share/git/completion/git-completion.bash' >> ~/.bashrc

# https://kind.sigs.k8s.io/docs/user/quick-start/
GO111MODULE="on" go get sigs.k8s.io/kind@v0.9.0
echo 'export PATH="$(go env GOPATH)/bin:$PATH"' >> ~/.bashrc

# AUR setup and install AUR packages
#  openvpn-update-resolv-conf-git
# slack-desktop

# For spotify, we need to import the key, https://aur.archlinux.org/packages/spotify/
# curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -
# spotify

# nvm
echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.bashrc
nvm install --lts
nvm use --lts

# serverless
npm install -g serverless
# https://github.com/serverless/serverless/issues/5124
# remove annoying plugin automatically installed by serverless
sed -i '/tabtab/d' ~/.bashrc

# install vim plugins
mkdir -p ~/.vim/pack/bundle/start
cd ~/.vim/pack/bundle/start
git clone https://github.com/mbbill/undotree.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/tpope/vim-rhubarb
git clone https://github.com/tpope/vim-unimpaired
git clone https://github.com/tpope/vim-commentary.git
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/dense-analysis/ale.git
git clone git@github.com:natebosch/vim-lsc.git
git clone https://github.com/junegunn/fzf.vim
git clone https://github.com/hashivim/vim-terraform.git
git clone git@github.com:godlygeek/tabular.git
git clone https://github.com/tpope/vim-vinegar.git

# setup git
git config --global user.name "Ed Tan"
git config --global user.email edtan@users.noreply.github.com
git config merge.tool vimdiff
git config merge.conflictstyle diff3
git config mergetool.prompt false
git config --global core.editor "vim"
git config --global mergetool.keepBackup false


# https://www.mfitzp.com/article/add-git-branch-name-to-terminal-prompt-mac/
cat << 'EOF' >> ~/.bashrc
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
if [[ ${EUID} == 0 ]] ; then
  PS1="\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$(parse_git_branch)\$\[\033[00m\] "
else
  PS1="\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$(parse_git_branch)\$\[\033[00m\] "
fi
EOF


# https://junegunn.kr/2016/07/fzf-git/
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
git clone git@github.com:edtan/dotfiles.git
sudo cp dotfiles/fzf-git/* /usr/share/fzf/

# https://github.com/junegunn/fzf/issues/337#issuecomment-136383876
echo "export FZF_DEFAULT_COMMAND='find .'" >> ~/.bashrc

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

echo "Checking grub timeout...  If non-zero, change it to 0 and then run 'sudo update-grub'.  alternatively, set timeout to 1 and timeout style to menu"
cat /etc/default/grub | grep GRUB_TIMEOUT
# sudo update-grub

# set efibootmgr timeout to 0 (seems to default to 5)
# sudo efibootmgr -t 0


# other
# https://hackmd.io/@dasgeek/S186eNUxL
