{
  description = ''
    Nomadics Modular Nixos
  '';

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs"; # Pin sops-nix to follow nixpkgs
    };
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.url = "github:nix-community/disko";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    dotfiles = {
      url = "git+https://github.com/nomadics9/dotfiles.git";
      flake = false;
    };
  };



  outputs = { self, home-manager, nixpkgs, dotfiles, sops-nix, arion, disko, ... }@inputs:
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
      user = "nomad";
      hostname = "unkown";
    in
    {
      packages =
        forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {

        unkown = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs user hostname; };
          modules = [
            ./hosts/${hostname}
            sops-nix.nixosModules.sops
            arion.nixosModules.arion
          ];
        };

        homelab = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs user; };
          modules = [
            ./hosts/homelab
            arion.nixosModules.arion
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
        };

        vps = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs user; };
          modules = [
            ./hosts/vps
            arion.nixosModules.arion
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
        };
      };

      homeConfigurations = {
        "${user}@${hostname}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs user; };
          modules = [
            ./home/${user}/${hostname}.nix
          ];
        };
      };
    };
}
