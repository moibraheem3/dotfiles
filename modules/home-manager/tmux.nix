{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    prefix = "C-a";
    terminal = "tmux-256color";
    historyLimit = 100000;
    escapeTime = 0;
    mouse = true;
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      # sensible
      vim-tmux-navigator
      # {
      #   plugin = catppuccin;
      #   extraConfig = ''
      #     set -g @catppuccin_flavour 'mocha' # or frappe, macchiato, mocha
      #   '';
      # }
      yank
      # resurrect
      # {
      #   plugin = continuum;
      #   extraConfig = ''
      #     set -g @continuum-restore 'on'
      #     set -g @continuum-boot 'on'
      #     set -g @continuum-save-interval '10'
      #   '';
      # }
    ];

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g focus-events on

      set -g set-clipboard on
      set -g status-position top
      set -g status-bg default
      set -g status-style bg=default
      set -g status-style fg=default
      set -g status-right ""
      set -g status-left-length 85
      set -g window-status-current-format "#[fg=black,bold bg=default]│#[fg=white bg=cyan]#W#[fg=black,bold bg=default]│"
      set -g window-status-current-format "#[fg=black,bold bg=default]│#[fg=colour135 bg=black]#W#[fg=black,bold bg=default]│"

      bind s set-option -g status
      bind - split-window -v -c "#{pane_current_path}"
      bind _ split-window -h -c "#{pane_current_path}"

      bind Enter copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind-key -r f run-shell "tmux neww ~/dotfiles/scripts/tmux-sessionizer.sh"
      bind-key -r k run-shell "~/dotfiles/scripts/tmux-sessionizer.sh ~/dotfiles"
      bind-key -n M-l send-keys 'C-l'
    '';
  };
}
