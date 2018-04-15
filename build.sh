#!/bin/bash
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --disable-static \
            --disable-doxygen-docs \
            --disable-xml-docs \
            --docdir=/usr/share/doc/dbus-1.12.6 \
            --with-console-auth-dir=/run/console && \
make -j $SHED_NUM_JOBS && \
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1
mkdir -v "${SHED_FAKE_ROOT}/lib"
mv -v "${SHED_FAKE_ROOT}"/usr/lib/libdbus-1.so.* "${SHED_FAKE_ROOT}/lib"
ln -sfv ../../lib/$(readlink "${SHED_FAKE_ROOT}/usr/lib/libdbus-1.so") "${SHED_FAKE_ROOT}/usr/lib/libdbus-1.so"
mkdir -pv "${SHED_FAKE_ROOT}/var/lib"
ln -sfv /etc/machine-id "${SHED_FAKE_ROOT}/var/lib/dbus"
