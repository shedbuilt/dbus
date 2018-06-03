#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_DOCDIR="/usr/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION}"
# Configure
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --disable-static \
            --disable-doxygen-docs \
            --disable-xml-docs \
            --docdir=$SHED_PKG_LOCAL_DOCDIR \
            --with-console-auth-dir=/run/console &&
# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install &&
# Rearrange
mv -v "${SHED_FAKE_ROOT}"/usr/lib/libdbus-1.so.* "${SHED_FAKE_ROOT}/lib" &&
ln -sfv ../../lib/$(readlink "${SHED_FAKE_ROOT}/usr/lib/libdbus-1.so") "${SHED_FAKE_ROOT}/usr/lib/libdbus-1.so" &&
mkdir -pv "${SHED_FAKE_ROOT}/var/lib" &&
ln -sfv /etc/machine-id "${SHED_FAKE_ROOT}/var/lib/dbus" || exit 1
# Optionally Remove Documentation
if [ -z "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    rm -rf "${SHED_FAKE_ROOT}/usr/share/doc"
fi
