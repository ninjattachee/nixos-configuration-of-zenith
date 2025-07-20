{ config, pkgs, lib, ... }:
{
  home.username = "atank";
  home.homeDirectory = "/home/atank";
  home.stateVersion = "25.05";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "fzf"
        "docker"
        #"nix-zsh-completions"
        #"you-should-use"
        "history-substring-search"
      ];
      theme = "cloud";
    };

    initContent = ''
      # 加载外部自定义配置
      source ~/.zshrc.local

      # fzf 配置
      source <(fzf --zsh)

      # autojump 配置
      . ${pkgs.autojump}/share/autojump/autojump.zsh

      # 确保 nix-zsh-completions 的路径在 fpath 中
      fpath+=${pkgs.nix-zsh-completions}/share/zsh/site-functions
      autoload -U compinit && compinit
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dimensions = {
          columns = 80;
          lines = 24;
        };
        padding = {
          x = 5;
          y = 5;
        };
        dynamic_padding = true;
        decorations = "none";
        opacity = 0.9;
        startup_mode = "Windowed";
      };

      font = {
        normal = {
          family = "Fira Code"; # 字体名称
          style = "Regular";
        };
        bold = {
          family = "Fira Code";
          style = "Bold";
        };
        italic = {
          family = "Fira Code";
          style = "Italic";
        };
        size = 12; # 字体大小
      };

      cursor = {
        style = {
          shape = "Block"; # 光标形状：Block, Underline, Beam
          blinking = "On"; # 光标闪烁：On, Off
        };
        blink_interval = 750; # 闪烁间隔（毫秒）
        unfocused_hollow = true; # 窗口未聚焦时光标是否为空心
      };
    };
  };

  programs.neovim = {
  enable = true;
  viAlias = true;
  vimAlias = true;
  extraConfig = ''
    lua << EOF
    -- Bootstrap Lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
      })
    end
    vim.opt.rtp:prepend(lazypath)

    -- Setup Lazy.nvim
    require("lazy").setup({
      spec = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        { "neovim/nvim-lspconfig" },
        { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
        { "tpope/vim-fugitive" },
      },
      install = { colorscheme = { "tokyonight" } },
      checker = { enabled = true },
    })

    -- Set colorscheme
    vim.cmd.colorscheme("tokyonight")

    -- Enable line numbers
    vim.opt.number = true

    -- Basic keymaps for Telescope
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

    -- Configure nvim-treesitter
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "python", "javascript" },
      highlight = { enable = true },
    })
    EOF
  '';
};

  home = {
    packages = with pkgs; [
      fzf
      autojump
      zsh-autosuggestions
      zsh-syntax-highlighting
      zsh-completions
      fira-code
      fira-code-symbols
      tmux
      ffmpeg
      go
      shotcut
      sqlite
      postgresql
      httpie
      wineWowPackages.unstable
      winetricks # configure wine
    ];
  };
}
