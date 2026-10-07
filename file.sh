comm -13 \
	<(grep -h -E '^\s*(linux|initrd)\s+/EFI/nixos/' /boot/EFI/nixos/*nixos*.conf 2>/dev/null | sed 's|.*/EFI/nixos/||' | sort -u) \
	<(sudo -S find /boot/EFI/nixos/ -maxdepth 1 -name '*.efi' -printf '%f\n' | sort) | sed 's|^|Would delete: /boot/EFI/nixos/|' \
	| xargs -d '\n' --no-run-if-empty printf '%s\n'
