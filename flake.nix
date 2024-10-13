{
  description = ''
    Nomadics Modular Nixos
  '';

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    dotfiles = {
      url = "git+https://github.com/nomadics9/dotfiles.git";
      flake = false;
    };
  };



  outputs = { self, home-manager, nixpkgs, dotfiles, ... }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      user = "nomad2";
      hostname = "unkown2";
    in
    {
      packages =
        forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        unkown = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs user hostname; };
          modules = [ ./hosts/${hostname} ];
        };
      };
      homeConfigurations = {
        "${user}@${hostname}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs user; };
          modules = [ ./home/${user}/${hostname}.nix ];
        };
      };
    };
}
