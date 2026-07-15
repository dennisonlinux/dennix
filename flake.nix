{
    description = "welcome to dennix";

    inputs = {
      nixpkgs.url = "nixpkgs/nixos-26.05";
      nixos-hardware = {
        url = "github:NixOS/nixos-hardware";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      home-manager = {
        url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      stylix = {
        url = "github:nix-community/stylix/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
   };

    outputs = { self, nixpkgs, home-manager, stylix, nixos-hardware, ... }: {
        nixosConfigurations.t440p =
    nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          nixos-hardware.nixosModules.lenovo-thinkpad-t440p

           {
              home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.dennis = import ./home.nix;
                  backupFileExtension = "bak";
             };
           }
         ];
       };
     };
}
