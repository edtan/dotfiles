#!/bin/bash

# https://wiki.archlinux.org/index.php/PC_speaker
sudo rmmod pcspkr
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

sudo pacman -Syu

sudo pacman -S \
  cmake \
  code \
  docker \
  docker-compose \
  flake8 \
  freerdp \
  fzf \
  geckodriver \
  go \
  gvim \
  graphviz \
  jdk8-openjdk \
  helm \
  keepassxc \
  kubectl \
  nvm \
  python-graphviz \
  python-language-server \
  terraform \
  tree \
  ttf-ms-fonts \
  vagrant \
  xclip

sudo systemctl enable docker
sudo systemctl start docker
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
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
git clone https://github.com/mbbill/undotree.git
git clone https://github.com/tpope/vim-fugitive.git
# Install help for vim-fugitive
vim -u NONE -c "helptags vim-fugitive/doc" -c q
git clone https://github.com/tpope/vim-commentary.git
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/dense-analysis/ale.git
git clone https://github.com/junegunn/fzf.vim
git clone https://github.com/tpope/vim-rhubarb


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
