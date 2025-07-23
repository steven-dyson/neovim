source "$(dirname "$0")/helpers.sh"

PKG_MGR=$(get_pkg_mgr)

echo "$PKG_MGR"

# Logging
LOG_DIR="./.logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install_languages.log"

# Go
install_go() {
	GO_VERSION=1.24.5

	if command -v go &>/dev/null && [[ "$(go version)" == *"${GO_VERSION}"* ]]; then
		echo "✅ Go ${GO_VERSION} already installed"
	else
		GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
		INSTALL_DIR="/usr/local"

		wget -O "${GO_TAR}" "https://go.dev/dl/${GO_TAR}" > >(write_to_log) 2>&1

		sudo rm -rf "${INSTALL_DIR}/go"

		sudo tar -C "${INSTALL_DIR}" -xzf "${GO_TAR}"

		rm "${GO_TAR}"

		echo "✅ Go ${GO_VERSION} installed to ${INSTALL_DIR}/go"
	fi

	set_path "/usr/local/go/bin"
	set_path '$HOME/go/bin'
}
handle_install "Go" install_go go

# Python
# TODO: If python is installed it will skip
install_python() {
	echo "Using $PKG_MGR"
	eval "$PKG_MGR" install python3 python3-venv -y > >(write_to_log) 2>&1
	set_alias "python" "python3"
	set_alias "py" "python3"
}
handle_install "Python" install_python python3

# Node and NVM
install_nvm() {
	if [ -z "${XDG_CONFIG_HOME-}" ]; then
		export NVM_DIR="${HOME}/.nvm"
	else
		export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
	fi

	if [ ! -s "$NVM_DIR/nvm.sh" ]; then
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash > >(write_to_log) 2>&1
	fi

	if [ -s "$NVM_DIR/nvm.sh" ]; then
		. "$NVM_DIR/nvm.sh"
	fi

	if ! nvm ls 20 | grep -q "v20"; then
		nvm install 20 > >(write_to_log) 2>&1
		nvm alias default 20 > >(write_to_log) 2>&1
	fi
}
handle_install "NVM" install_nvm nvm
