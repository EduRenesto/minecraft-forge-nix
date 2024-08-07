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
  in rec {
    packages = rec {
      minecraftServers.forge-1-20 = pkgs.callPackage ./packages/forge-server.nix {  };
      default = minecraftServers.forge-1-20;
    };

    overlays.default = prev: next: {
      minecraftServers.forge-1-20 = packages.minecraftServers.forge-1-20;
    };
  });
}
