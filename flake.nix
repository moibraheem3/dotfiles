{
  description = "Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=3"; # hyprland development
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay/";
  };
  outputs = {
    nixpkgs,
    # home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    host = "laptop";
    username = "mohamed";
  in {
    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit host;
        inherit username;
        inherit system;
      };
      modules = [
        ./hosts/${host}/configuration.nix
        # home-manager.nixosModules.home-manager
        # {
        #   home-manager.extraSpecialArgs = {
        #     inherit inputs;
        #     inherit username;
        #     inherit host;
        #     inherit system;
        #   };
        #   home-manager.useGlobalPkgs = true;
        #   home-manager.useUserPackages = true;
        #   home-manager.users.${username} = import ./hosts/${host}/home.nix;
        # }
      ];
    };
  };
}
