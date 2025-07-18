GO_VERSION="${1:-1.24.5}"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
INSTALL_DIR="/usr/local"

wget -O "${GO_TAR}" "https://go.dev/dl/${GO_TAR}"

sudo rm -rf "${INSTALL_DIR}/go"

sudo tar -C "${INSTALL_DIR}" -xzf "${GO_TAR}"

rm "${GO_TAR}"

echo "✅ Go ${GO_VERSION} installed to ${INSTALL_DIR}/go"
