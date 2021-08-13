# Automatically use sudo if it is required by pacman

pacman() {
	case $1 in
		autoremove)
			/usr/bin/pacman -Qtdq | /usr/bin/sudo /usr/bin/pacman -Rns -
			;;
		-S | -D | -S[^sih]* | -R* | -U*)
			/usr/bin/sudo /usr/bin/pacman "$@"
			;;
		*)
			/usr/bin/pacman "$@"
			;;
	esac
}
