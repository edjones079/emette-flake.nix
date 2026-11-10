{ config, pkgs, ... }:

{
	home.username = "emettej";
	home.homeDirectory = "/home/emettej";

	#programs.home-manager.enable = true;
	
	imports = [
#		./hyprland.nix
	];

	home.packages = with pkgs; [
	
	];

	#wayland.windowManager.hyprland.enable = true;
	#wayland.windowManager.hyprland.settings = {

		

	#};

	home.stateVersion = "26.05";
}
