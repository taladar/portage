# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/ceph/ceph-0.25.2.ebuild,v 1.4 2011/04/01 12:11:38 ultrabug Exp $

EAPI="3"

inherit autotools eutils multilib

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="http://ceph.newdream.net/"
SRC_URI="http://ceph.newdream.net/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug fuse gtk libatomic radosgw static-libs"

CDEPEND="
	dev-libs/boost
	dev-libs/libedit
	dev-libs/crypto++
	fuse? ( sys-fs/fuse )
	libatomic? ( dev-libs/libatomic_ops )
	gtk? (
			x11-libs/gtk+:2
			dev-cpp/gtkmm:2.4
		)
	radosgw? (
				dev-libs/fcgi
				dev-libs/expat
			)
	"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}
	sys-fs/btrfs-progs"

src_prepare() {
	sed -e 's:invoke-rc\.d.*:/etc/init.d/ceph reload >/dev/null:' \
		-i src/logrotate.conf || die
	sed -i "/^docdir =/d" src/Makefile.am || die #fix doc path
	# disable testsnaps
	sed -e '/testsnaps/d' -i src/Makefile.am || die
	# fix Spinlock.h include path, wrt #361203
	sed -i -e 's|#include "Spinlock.h"|#include "include/Spinlock.h"|g' src/include/rados/atomic.h || die
	epatch "${FILESDIR}/${PN}-0.24.1-autotools.patch"
	eautoreconf
}

src_configure() {
	econf \
		--without-hadoop \
		--without-tcmalloc \
		--docdir=/usr/share/doc/${PF} \
		--includedir=/usr/include \
		$(use_with debug) \
		$(use_with fuse) \
		$(use_with libatomic libatomic-ops) \
		$(use_with radosgw) \
		$(use_with gtk gtk2) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${D}" -type f -name "*.la" -exec rm -f {} \;

	rmdir "${D}/usr/sbin"

	exeinto /usr/$(get_libdir)/ceph || die
	newexe src/init-ceph ceph_init.sh || die

	insinto /etc/logrotate.d/ || die
	newins src/logrotate.conf ${PN} || die

	chmod 644 "${D}"/usr/share/doc/${PF}/sample.* || die

	keepdir /var/lib/${PN} || die
	keepdir /var/lib/${PN}/tmp || die
	keepdir /var/log/${PN}/stat || die
	keepdir /var/run/${PN} || die

	newinitd "${FILESDIR}/${PN}.initd" ${PN} || die
	newconfd "${FILESDIR}/${PN}.confd" ${PN} || die
}
