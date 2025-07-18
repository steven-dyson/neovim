GO_VERSION="${1:-1.24.5}"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
INSTALL_DIR="/usr/local"

wget "https://go.dev/dl/${GO_TAR}"
rm -rf /usr/local/go
tar -C "${INSTALL_DIR}" -xzf "${GO_TAR}"
rm "${GO_TAR}"
echo "✅ Go ${GO_VERSION} installed to ${INSTALL_DIR}/go"
