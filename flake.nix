{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    steam-fetcher = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/steam-fetcher";
    };
  };
  outputs =
    {
      nixpkgs,
      self,
      steam-fetcher,
      ...
    }:
    {
      nixosModules.default =
        { ... }:
        {
          imports = [
            ./nixos/modules/services/games/palworld-server.nix
          ];
          nixpkgs.overlays = [ self.overlays.default ];
        };
      overlays.default = nixpkgs.lib.composeManyExtensions [
        (
          final: prev:
          let
            pkgs = final.appendOverlays [ steam-fetcher.overlays.default ];
          in
          {
            palworld-server = pkgs.callPackage ./pkgs/by-name/pa/palworld-server { };
            palworld-server-unwrapped = pkgs.callPackage ./pkgs/by-name/pa/palworld-server-unwrapped { };
          }
        )
      ];
      packages.x86_64-linux = {
        inherit (nixpkgs.legacyPackages.x86_64-linux.appendOverlays [ self.overlays.default ])
          palworld-server
          palworld-server-unwrapped
          ;
      };
    };
}
