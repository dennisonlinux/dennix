{
    description = "welcome to dennix";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-26.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }: {
        nixosConfigurations.t440p =
    nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
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
