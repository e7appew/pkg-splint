#!/bin/sh

set -e
set -u

PKG_NAME="splint"
PKG_VERS="$2"
DFSG_VERS="dfsg"
UPSTR_SITE="http://www.${PKG_NAME}.org"
UPSTR_DIR="${PKG_NAME}-${PKG_VERS}"
UPSTR_FILE="$3"
UPSTR_FILE_DIR="$(dirname "$UPSTR_FILE")"
DFSG_ORIG_DIR="${UPSTR_DIR}.orig"
DFSG_ORIG_TAR="${PKG_NAME}_${PKG_VERS}+${DFSG_VERS}.orig.tar"

TMP_DIR="$(mktemp -d ./tmp-repack.XXXXXX)"
trap "rm -rf \"$TMP_DIR\"" QUIT INT EXIT

tar -xzpf "${UPSTR_FILE}" -C "${TMP_DIR}"
mv "${TMP_DIR}/${UPSTR_DIR}" "${TMP_DIR}/${DFSG_ORIG_DIR}"
rm -f "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/manual.pdf"
mv -f "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/manual.css" "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/html"
mkdir "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/html/manual-301_files"
wget -q "${UPSTR_SITE}/manual/manual-301_files/image001.jpg" -O "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/html/manual-301_files/image001.jpg"
wget -q "${UPSTR_SITE}/manual/manual-301_files/image002.gif" -O "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/html/manual-301_files/image002.gif"
wget -q "${UPSTR_SITE}/manual/manual-301_files/image003.gif" -O "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/html/manual-301_files/image003.gif"
wget -q "${UPSTR_SITE}/faq.html" -O "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/html/faq.html"
wget -q "${UPSTR_SITE}/changes.html" -O "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/changes.html"
wget -q "${UPSTR_SITE}/bugs.html" -O "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/bugs.html"
wget -q "${UPSTR_SITE}/splint.css" -O "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/html/splint.css"
wget -q "${UPSTR_SITE}/glowingwall-narrows.jpg" -O "${TMP_DIR}/${DFSG_ORIG_DIR}/doc/html/glowingwall-narrows.jpg"
tar -cpf "${TMP_DIR}/${DFSG_ORIG_TAR}" --owner root --group root -C "${TMP_DIR}" "${DFSG_ORIG_DIR}"
xz -9 "${TMP_DIR}/${DFSG_ORIG_TAR}"
mv "${TMP_DIR}/${DFSG_ORIG_TAR}.xz" "${UPSTR_FILE_DIR}"

echo "Re-packaged source file: ${DFSG_ORIG_TAR}.xz"

ls -l "${UPSTR_FILE_DIR}/${DFSG_ORIG_TAR}.xz"
