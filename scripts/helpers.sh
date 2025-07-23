get_pkg_mgr() {
	if command -v apt &>/dev/null; then
		echo "sudo apt"
	elif command -v brew &>/dev/null; then
		echo "brew"
	else
		echo "❌ No supported package manager found (apt or brew required). Exiting."
		exit 1
	fi
}

# arg1: directory to add to PATH
set_path() {
	if [[ ":$PATH:" != *":$1:"* ]]; then
		if ! grep -q "export PATH=\"$1:\$PATH\"" ~/.bashrc; then
			echo "🔧 Adding $1 to PATH in .bashrc"
			echo "export PATH=\"$1:\$PATH\"" >>~/.bashrc
		else
			echo "⚠️  $1 already referenced in .bashrc"
		fi
		export PATH="$1:$PATH"
	else
		echo "✅ $1 already in PATH"
	fi
}

set_alias() {
	local to=$1
	local from=$2

	target="$HOME/.bash_aliases"

	if ! test -f "$target"; then
		touch "$target"
	fi

	if ! grep -q "alias $to=" "$target"; then
		echo "alias $to=\"$from\"" >>"$target"
	fi
}

write_to_log() {
	local logfile="./.logs/install.log"
	mkdir -p "$(dirname "$logfile")"

	while IFS= read -r line; do
		echo "$line" >>"$logfile"
	done
}

# arg1: package manager (e.g., apt)
# arg2: command to check (e.g., go)
# arg3: package name to install (e.g., golang), empty string if not used
handle_install() {
	local name=$1
	local fnc=$2
	local cmd=$3

	if ! command -v "$cmd" &>/dev/null; then
		read -rp "🤔 Do you want to install $name? (y/N) " answer
		if [[ "${answer,,}" == "y" ]]; then
			echo "🟢 Installing $name..."
			"$fnc"
		else
			echo "❌ Skipping installation of $name"
		fi
	else
		echo "📦 $name is already installed"
	fi
}
