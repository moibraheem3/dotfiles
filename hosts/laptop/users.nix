{
  pkgs,
  username,
  ...
}: let
  inherit (import ./variables.nix) gitUsername;
in {
  users.users = {
    ${username} = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = ["networkmanager" "wheel" "docker"];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
      packages = [];
    };
  };
}
