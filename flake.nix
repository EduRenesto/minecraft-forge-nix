{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages = rec {
      minecraftServers.forge-1-20 = pkgs.callPackage ./packages/forge-server.nix {  };
      default = minecraftServers.forge-1-20;
    };
  });
}
