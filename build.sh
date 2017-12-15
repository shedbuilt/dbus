#!/bin/bash
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --disable-static \
            --disable-doxygen-docs \
            --disable-xml-docs \
            --docdir=/usr/share/doc/dbus-1.10.22 \
            --with-console-auth-dir=/run/console
make -j $SHED_NUMJOBS
make DESTDIR=${SHED_FAKEROOT} install
mkdir -v ${SHED_FAKEROOT}/lib
mv -v ${SHED_FAKEROOT}/usr/lib/libdbus-1.so.* ${SHED_FAKEROOT}/lib
ln -sfv ../../lib/$(readlink ${SHED_FAKEROOT}/usr/lib/libdbus-1.so) ${SHED_FAKEROOT}/usr/lib/libdbus-1.so
mkdir -pv ${SHED_FAKEROOT}/var/lib
ln -sfv /etc/machine-id ${SHED_FAKEROOT}/var/lib/dbus
