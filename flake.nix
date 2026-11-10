# Flake - An attribute set of inputs / outputs.

{
	description = "EmFlake";

	# Inputs - An nested attribute set that contains key-value pairs of external nix expressions!

	inputs = {

		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

		home-manager = {

			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";

		};

		# nixgl.url = "github:nix-community/nixGL";

		firefox.url = "github:nix-community/flake-firefox-nightly";
		firefox.inputs.nixpkgs.follows = "nixpkgs";

		hyprland.url = "github:hyprwm/Hyprland";

		rose-pine-hyprcursor = {

			url = "github:ndom91/rose-pine-hyprcursor";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.hyprlang.follows = "hyprland/hyprlang";

		};

		nbfc-linux = {
      
			url = "github:nbfc-linux/nbfc-linux?dir=pkgbuilds/nix";
			inputs.nixpkgs.follows = "nixpkgs";

		};

	};

	# Outputs - A function that takes an attribute set of inputs to build the declared outputs!

	outputs = { self, nixpkgs, home-manager, ... }@inputs: 

	# Define local variables for use in system & user configuration!

	let
		# inherit - Create copy of variables & functionz from lib.nix!

		inherit (nixpkgs) lib; # lib = nixpkgs.lib;

		# import - Load, parse, and return Nix expression in the file path!

		util = import ./lib {  # util = lib.$(functions);
			inherit system pkgs home-manager lib; overlays = (pkgs.overlays);
		};

		inherit (util) user; # user = util.user;
		inherit (util) host; # host = util.host;

		pkgs = import nixpkgs {

			inherit system; # system = system;
			config.allowUnfree = true; # nixpkgs.config.allowUnfree = true;
			overlays = []; # overlays = [];

		};
	
		system = "x86_64-linux";
  	in
  	{
    
		nixosConfigurations = { 

			wander = nixpkgs.lib.nixosSystem {

				specialArgs = { inherit inputs; };
				modules = [
	
					./hosts/wander/modules/configuration.nix
					./hosts/wander/modules/fhs.nix

					home-manager.nixosModules.default
					{

						home-manager = {

	    						useGlobalPkgs = true;
	    						useUserPackages = true;
	    						extraSpecialArgs = { inherit inputs; };
	    						users.electrickazoo = import ./hosts/wander/home.nix;

	  					};

					}

				];

    			};

			#framework = hosts.mkHost {
			#	name = "agro";
			#	NICs = [ "wlp2s0" "lo" "eth0" "p2p-dev-wlp1s0" ];
			#	kernelPackage = pkgs.linuxPackages;
			#	initrdMods = [ 
			#		"xhci_pci"
			#		"nvme"
			#		"usb_storage"
			#		"sd_mod"
			#		"thunderbolt"
			#		"usbhid"
			#	];
			#	kernelMods = [ "kvm-amd" ];
			#	kernelParams = [];
			#	systemConfig = { };

			#	users = [{
			#		name = "emettej";
			#		groups = [ "wheel" "networkmanager" "video" ];
			#		udi = 1000;
			#	}];

			#	cpuCores = 4;
			#};

    			agro = nixpkgs.lib.nixosSystem {

				specialArgs = { inherit inputs; };
				modules = [

					./hosts/agro/modules/configuration.nix

					home-manager.nixosModules.home-manager
					{

						home-manager = {

	    						useGlobalPkgs = true;
	    						useUserPackages = true;
	    						extraSpecialArgs = { inherit inputs; };
	    						users.emettej = import ./hosts/agro/modules/home.nix;

	  					};

					}

				];

			};
		};
	};

}
