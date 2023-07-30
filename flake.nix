{
  description = "Joe's NixOS and Home Manager Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs at the
    # same time. See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs =
    { self
    , nix-formatter-pack
    , nixpkgs
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "23.05";
      libx = import ./lib { inherit inputs outputs stateVersion; };
    in
    {
      # home-manager switch -b backup --flake $HOME/Zero/nix-config
      # nix build .#homeConfigurations."joe@hydrogen".activationPackage
      homeConfigurations = {
        # .iso images
        "joe@iso-console" = libx.mkHome { hostname = "iso-console"; username = "nixos"; };
        "joe@iso-desktop" = libx.mkHome { hostname = "iso-desktop"; username = "nixos"; desktop = "pantheon"; };
        # Workstations
        "joe@hydrogen" = libx.mkHome { hostname = "hydrogen"; username = "joe"; desktop = "pantheon"; };
        "joe@oxygen" = libx.mkHome { hostname = "oxygen"; username = "joe"; desktop = "pantheon"; };
        "joe@lithium" = libx.mkHome { hostname = "lithium"; username = "joe"; desktop = "gnome"; };
        "joe@carbon" = libx.mkHome { hostname = "carbon"; username = "joe"; desktop = "pantheon"; };
        # Servers
        "joe@helium" = libx.mkHome { hostname = "helium"; username = "joe"; };
        "joe@neon" = libx.mkHome { hostname = "neon"; username = "joe"; };
        "joe@silver" = libx.mkHome { hostname = "silver"; username = "joe"; };
        "joe@gold" = libx.mkHome { hostname = "gold"; username = "joe"; };
        "joe@nitrogen" = libx.mkHome { hostname = "nitrogen"; username = "joe"; };
        "joe@lithium-mini" = libx.mkHome { hostname = "lithium-mini"; username = "joe"; };
      };
      nixosConfigurations = {
        # .iso images
        #  - nix build .#nixosConfigurations.{iso-console|iso-desktop}.config.system.build.isoImage
        iso-console = libx.mkHost { hostname = "iso-console"; username = "nixos"; installer = nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"; };
        iso-desktop = libx.mkHost { hostname = "iso-desktop"; username = "nixos"; installer = nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"; desktop = "pantheon"; };
        iso-gpd-edp = libx.mkHost { hostname = "iso-gpd-edp"; username = "nixos"; installer = nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"; desktop = "pantheon"; };
        iso-gpd-dsi = libx.mkHost { hostname = "iso-gpd-dsi"; username = "nixos"; installer = nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"; desktop = "pantheon"; };
        # Workstations
        #  - sudo nixos-rebuild switch --flake $HOME/Zero/nix-config
        #  - nix build .#nixosConfigurations.hydrogen.config.system.build.toplevel
        hydrogen = libx.mkHost { hostname = "hydrogen"; username = "joe"; desktop = "pantheon"; };
        oxygen = libx.mkHost { hostname = "oxygen"; username = "joe"; desktop = "pantheon"; };
        lithium = libx.mkHost { hostname = "lithium"; username = "joe"; desktop = "gnome"; };
        carbon = libx.mkHost { hostname = "carbon"; username = "joe"; desktop = "pantheon"; };
        # Servers
        helium = libx.mkHost { hostname = "helium"; username = "joe"; };
        neon = libx.mkHost { hostname = "neon"; username = "joe"; };
        silver = libx.mkHost { hostname = "silver"; username = "joe"; };
        gold = libx.mkHost { hostname = "gold"; username = "joe"; };
        nitrogen = libx.mkHost { hostname = "nitrogen"; username = "joe"; };
        lithium-mini = libx.mkHost { hostname = "lithium-mini"; username = "joe"; };
      };

      # Devshell for bootstrapping; acessible via 'nix develop' or 'nix-shell' (legacy)
      devShells = libx.forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # nix fmt
      formatter = libx.forAllSystems (system:
        nix-formatter-pack.lib.mkFormatter {
          pkgs = nixpkgs.legacyPackages.${system};
          config.tools = {
            alejandra.enable = false;
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            statix.enable = true;
          };
        }
      );

      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      # Custom packages; acessible via 'nix build', 'nix shell', etc
      packages = libx.forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
    };
}
