{ config, lib, pkgs, ... }:

let 
  # compile with darwin support (and xterm_clipboard disabled)
  # https://github.com/vim/vim/issues/2528
  # https://hardselius.github.io/vim-nix-darwin/
  # https://github.com/Homebrew/legacy-homebrew/issues/32875
  # https://unix.stackexchange.com/questions/117073/configuring-vim-with-clientserver-and-clipboard
  # https://github.com/vim/vim/issues/203
  # https://github.com/nix-community/home-manager/issues/412
  my_vim_configurable = pkgs.vim_configurable.override {
    guiSupport = "no";
    darwinSupport = true;
  };

  my_vimPlugins = with pkgs.vimPlugins; [
    vim-fugitive
    vim-rhubarb
    vim-unimpaired
    vim-commentary
    vim-surround
    vim-vinegar
    undotree
    fzf-vim
  ];

in

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ed";
  home.homeDirectory = lib.mkMerge [
    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux "/home/ed")
    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "/Users/ed")
  ];

  home.packages = [
    pkgs.jq
    pkgs.llvm
    pkgs.tree
    (my_vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = builtins.readFile /Users/ed/dotfiles/vimrc;
      vimrcConfig.packages.myVimPackages = {
        start = my_vimPlugins;
      };
    })
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    initExtra = ''
      # https://github.com/NixOS/nix/issues/2280#issuecomment-1173839877
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix

      # https://nix-community.github.io/home-manager/index.html
      export NIX_PATH=''$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}

      # https://medium.com/pareture/simplest-zsh-prompt-configs-for-git-branch-name-3d01602a6f33
      # Find and set branch name var if in git repository.
      function git_branch_name()
      {
        branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
        if [[ $branch == "" ]];
        then
          :
        else
          echo '- ('$branch')'
        fi
      }

      # Enable substitution in the prompt.
      setopt prompt_subst

      # Config for prompt. PS1 synonym.
      # https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
      prompt='%0/ $(git_branch_name) %# '

      # https://superuser.com/a/1522945
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word

      export PATH="/Users/ed/.ghcup/bin:$PATH"
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "find .";
  };

  programs.git = {
    enable = true;
    userName = "Ed Tan";
    userEmail = "edtan@users.noreply.github.com";
  };

}
