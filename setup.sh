#!/usr/bin/env bash

####################################################
# UDROID installer Script V03 (mad installer)
# A script made by udroid team
# Copyright (c) 2021 @RandomCoderOrg
# Modified for anroot by crossberryweb

version="3.2"
version_code_name="rev01"
installer_authors="crossberryweb"

# COLORS
_c_magneta="\e[1;49;95m"
_c_magneta_line="\e[4;49;95m"
_c_green="\e[1;49;32m"
_c_red="\e[1;49;91m"
_c_blue="\e[1;49;94m"
RST="\e[0m"

# BLOCK ALL EXIT SIGNALS - NO Ctrl+C ALLOWED
trap '' HUP INT QUIT TSTP TERM

## current best distro
CUR_BEST_DISTRO="jammy:xfce4"
FSMGR_REPO="https://github.com/crossberry-in/anroot.git"
FSMGR_BRANCH="main"
install_count="$(curl https://udroid-download-counter-api.vercel.app/count)"

# Config paths
CONFIG_DIR="$HOME/.config/anroot"
CONFIG_FILE="$CONFIG_DIR/anroot.toml"

die() { echo -e "${_c_red}[E] ${*}${RST}";if [ -n "$DISABLE_EXIT" ];then exit 1; fi;:;}
warn() { echo -e "${_c_red}[W] ${*}${RST}";:;}
shout() { echo -e "${_c_blue}[-] ${*}${RST}";:;}
lshout() { echo -e "${_c_blue}-> ${*}${RST}";:;}
msg() { echo -e "${*} \e[0m" >&2;:;}
banner_msg() { echo -e "\e[1;49;97m ${*} \e[0m" >&2;:;}

########################################
# TOML CONFIG FUNCTIONS
########################################

read_toml() {
	local key="$1"
	local file="$2"
	if [ -f "$file" ]; then
		grep "^${key} = " "$file" | sed 's/.*= "\(.*\)"/\1/' | tr -d '"'
	fi
}

write_toml() {
	local key="$1"
	local value="$2"
	local file="$3"
	mkdir -p "$CONFIG_DIR"
	if grep -q "^${key} = " "$file" 2>/dev/null; then
		sed -i "s|^${key} = .*|${key} = \"${value}\"|" "$file"
	else
		echo "${key} = \"${value}\"" >> "$file"
	fi
}

init_config() {
	mkdir -p "$CONFIG_DIR"
	if [ ! -f "$CONFIG_FILE" ]; then
		cat > "$CONFIG_FILE" <<EOF
# anroot configuration file
# Created by crossberryweb

[install]
installed = "false"
distro = "$CUR_BEST_DISTRO"
auto_login = "true"

[settings]
version = "$version"
author = "$installer_authors"
EOF
	fi
}

########################################
# LOGO TOOLS
########################################
update_log() { echo -e "${_c_blue}[*] ${*}${RST}"; }
progress_bar() { sleep 0.5; }

install_logo_tools() {
	update_log "Installing figlet..."
	pkg install -y figlet >/dev/null 2>&1
	progress_bar

	update_log "Installing lolcat..."
	pkg install -y ruby >/dev/null 2>&1
	gem install lolcat >/dev/null 2>&1
	progress_bar
}

########################################
# LOGO
########################################
function logo() {
	clear
	figlet -f slant "anroot" | lolcat 2>/dev/null || echo -e "${_c_magneta}    anroot${_c_green}CrossLinux${RST}"
	echo -e "${_c_green}CrossLinux v${version}${RST}"
	echo -e "${_c_magneta}Created by crossberry.vercel.app${RST}"
	echo
	lshout "${install_count} installs so far \e[0m...."
	sleep 1
}

########################################
# DEPENDENCY CHECK & AUTO INSTALL
########################################
DEPENDS="git jq wget proot pv pulseaudio openssl figlet ruby"

check_and_install_deps() {
	local TOINSTALL=""
	for DEPEND in $DEPENDS; do
		if [ -z "$(command -v "$DEPEND")" ]; then
			TOINSTALL="$TOINSTALL $DEPEND"
		fi
	done
	
	if [ -n "$TOINSTALL" ]; then
		lshout "Missing tools detected: $TOINSTALL"
		lshout "Auto-installing missing packages..."
		pkg install -y $TOINSTALL || {
			die "Failed to install required packages."
		}
	fi
	
	# Check lolcat separately (gem install)
	if ! command -v lolcat >/dev/null 2>&1; then
		lshout "Installing lolcat gem..."
		gem install lolcat >/dev/null 2>&1
	fi
}

########################################
# AUTO LOGIN MODE
########################################
auto_login() {
	clear
	# Check and install any missing tools before login
	check_and_install_deps
	
	# Install logo tools if figlet/lolcat missing
	if ! command -v figlet >/dev/null 2>&1 || ! command -v lolcat >/dev/null 2>&1; then
		install_logo_tools
	fi
	
	logo
	lshout "Auto-logging into $CUR_BEST_DISTRO..."
	sleep 1
	udroid login "$CUR_BEST_DISTRO"
	exit 0
}

########################################
# MAIN LOGIC
########################################

# Setup Termux storage access first (auto-confirm y)
echo "y" | termux-setup-storage

# Initialize config
init_config

# Check if already installed
INSTALLED=$(read_toml "installed" "$CONFIG_FILE")

if [ "$INSTALLED" = "true" ]; then
	AUTO_LOGIN=$(read_toml "auto_login" "$CONFIG_FILE")
	if [ "$AUTO_LOGIN" = "true" ]; then
		auto_login
	else
		check_and_install_deps
		logo
		lshout "Already installed. Run 'udroid login $CUR_BEST_DISTRO' to start."
		exit 0
	fi
fi

# ==================== FRESH INSTALL FLOW ====================

# Check and install deps first
check_and_install_deps
install_logo_tools

logo

# Check device os & CPU architecture
lshout "Checking cpu architecture.."
if [ "$(uname -m)" = "armv7l" ]; then
	die "Sorry, armv7l is not supported.."
fi
msg "CPU architecture is OK."

# clone fs-manager-udroid
git clone -b $FSMGR_BRANCH $FSMGR_REPO || {
	die "Failed to clone fs-manager-udroid"
}
cd fs-manager-udroid || {
	die "Failed to cd into fs-manager-udroid"
}

# trigger install.sh
bash install.sh || {
	die "Failed to install fs-manager-udroid"
}

## finally install a good stable distro
lshout "Installing $CUR_BEST_DISTRO in 3 seconds.."
lshout "press q or CTRL+C to stop here.."
read -r -n 1 -t 3 noi
if [[ $noi == "q" ]]; then
	echo -e "\n\n"
	echo "q read: stopping $CUR_BEST_DISTRO installation.."
	echo "you can still install with: udroid l $CUR_BEST_DISTRO"
	echo
else
	udroid install $CUR_BEST_DISTRO || {
		die "Failed to install $CUR_BEST_DISTRO"
	}

	## Mark as installed in TOML
	write_toml "installed" "true" "$CONFIG_FILE"
	write_toml "distro" "$CUR_BEST_DISTRO" "$CONFIG_FILE"

	## show some info
	lshout "Installation completed successfully."
	lshout
	lshout "To login $CUR_BEST_DISTRO, run \"${_c_green}udroid login $CUR_BEST_DISTRO\""
	lshout "use ${_c_magneta}vncserver :1${RST} to start vnc server"
	lshout "default password for everything is ${_c_magneta}secret${RST}"
	lshout "Next time you run this script, it will auto-login!"
	lshout "Show us some love by starring our repo on github and donating"
	msg
	msg "ubuntu-on-android: ${_c_magneta_line}https://github.com/crossberry-in/anroot.git${RST}"
	msg "support us: ${_c_magneta_line}https://github.com/sponsors/crossberry-in${RST}"
	msg "Join our telegrame: ${_c_magneta_line}https://t.me/crossberry369${RST}"
	msg
fi
