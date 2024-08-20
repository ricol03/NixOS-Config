{
   inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/e95cc1274981e089d793531efab9c383915edad0";
      nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
      #nix-ld.url = "github:Mic92/nix-ld";
      home-manager = {
         url = "github:nix-community/home-manager/master";
         inputs.nixpkgs.follows = "nixpkgs";
      };
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      flatpaks.url = "github:GermanBread/declarative-flatpak/stable";
      #osu-nixos.url = "github:notgne2/osu-nixos/master";
      catppuccinifier = {
         url = "github:lighttigerXIV/catppuccinifier";
         inputs.nixpkgs.follows = "nixpkgs";
      };
      stylix.url = "github:danth/stylix";
      nixpkgs-vmware.url = "github:nixos/nixpkgs/377c250bbb888826a95496c328997c068d9b816d";
      #old hash:3d1f0b5af0a5d650d2ebe494fb3ffa921ff3dec0
      lagtrain.url = "github:ricol03/lagtrain-plymouth-theme";
      kwin-effects-forceblur = {
        url = "github:taj-ny/kwin-effects-forceblur";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      touhou-on-nixos.url = "github:gjz010/touhou-on-nixos";
      nix-touhou.url = "github:ricol03/nix-touhou";
      
   };
   
   outputs = { self, nixpkgs, nixpkgs-stable, home-manager, flatpaks, catppuccinifier, stylix, lagtrain, touhou-on-nixos, nix-touhou, ... }@inputs:
      
      let
      	lib = nixpkgs.lib;
      	system = "x86_64-linux";
      	pkgs = nixpkgs.legacyPackages.${system};
      	pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      in {
         nixosConfigurations = {
            NixOS-PC = lib.nixosSystem {
               inherit system;
               specialArgs = { inherit inputs; };
               modules = [ 
                 ./configuration.nix 
                 flatpaks.nixosModules.default 
                 #nix-ld.nixosModules.nix-ld
                 stylix.nixosModules.stylix
               ];
            };
            buildInputs = with pkgs; [ meson ninja pkg-config glib ];
         };
         homeConfigurations = {
            ricol03 = home-manager.lib.homeManagerConfiguration {
               inherit pkgs;
               modules = [ 
                 ./home.nix 
                 flatpaks.homeManagerModules.default 
                 stylix.homeManagerModules.stylix
               ];
            };
         };
      };


      
}
