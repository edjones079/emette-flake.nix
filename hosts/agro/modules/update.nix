{ config, pkgs, ... }:

{

	system.autoUpgrade = {

		enable = true;
		allowReboot = true;
		dates = "11:00";

	};

	nix.gc = {

		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";

	};

}
