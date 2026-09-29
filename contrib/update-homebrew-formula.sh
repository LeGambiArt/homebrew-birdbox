#!/usr/bin/env bash
# Update a Birdbox Homebrew formula for a new release.
# Usage: ./contrib/update-homebrew-formula.sh <formula> <version>

set -euo pipefail

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <formula> <version>"
    echo "Example: $0 arapuca 0.2.9"
    echo "Example: $0 wtmcp 0.1.8"
    exit 1
fi

FORMULA="$1"
VERSION="$2"

case "${FORMULA}" in
    arapuca)
        REPOSITORY="arapuca"
        ;;
    wtmcp)
        REPOSITORY="wtmcp"
        ;;
    *)
        echo "Error: Unsupported formula: ${FORMULA}"
        echo "Supported formulas: arapuca, wtmcp"
        exit 1
        ;;
esac

FORMULA_FILE="Formula/${FORMULA}.rb"
TARBALL_URL="https://github.com/LeGambiArt/${REPOSITORY}/archive/refs/tags/v${VERSION}.tar.gz"
TEMP_FILE=$(mktemp)
trap 'rm -f "${TEMP_FILE}"' EXIT

echo "Downloading ${REPOSITORY} ${VERSION} tarball..."
curl --fail --silent --show-error --location "${TARBALL_URL}" -o "${TEMP_FILE}"

echo "Calculating SHA256..."
if command -v sha256sum >/dev/null 2>&1; then
    SHA256=$(sha256sum "${TEMP_FILE}" | cut -d' ' -f1)
elif command -v shasum >/dev/null 2>&1; then
    SHA256=$(shasum -a 256 "${TEMP_FILE}" | cut -d' ' -f1)
else
    echo "Error: Neither sha256sum nor shasum found"
    exit 1
fi

if [ ! -f "${FORMULA_FILE}" ]; then
    echo "Error: Formula file not found: ${FORMULA_FILE}"
    exit 1
fi

sed -i.bak \
    -e "s|url \".*\"|url \"${TARBALL_URL}\"|" \
    -e "s|sha256 \".*\"|sha256 \"${SHA256}\"|" \
    "${FORMULA_FILE}"
rm -f "${FORMULA_FILE}.bak"

echo "Updated ${FORMULA_FILE}"
echo "Version: ${VERSION}"
echo "SHA256:  ${SHA256}"
echo
echo "Next steps:"
echo "1. Review the changes: git diff ${FORMULA_FILE}"
echo "2. Test the formula: brew install --build-from-source ${FORMULA_FILE}"
echo "3. Run the formula tests: brew test ${FORMULA}"
