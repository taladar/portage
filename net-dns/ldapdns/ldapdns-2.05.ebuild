# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/ldapdns/ldapdns-2.05.ebuild,v 1.11 2009/09/23 18:29:28 patrick Exp $

inherit eutils

DESCRIPTION="A tiny, fast authoritative nameserver that queries LDAP and can be updated instantly"
SRC_URI="http://www.nimh.org/dl/${P}.tar.gz"
HOMEPAGE="http://www.nimh.org/code/ldapdns/"
IUSE=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=">=net-nds/openldap-2"
RDEPEND="${DEPEND}
	>=sys-process/daemontools-0.70
	sys-apps/ucspi-tcp"

src_compile() {
	local myconf="--prefix=/usr "

	cd ${S}
	./configure ${myconf}
	emake || die "Compilation failed"
}

src_install() {
	einstall || die "Installation failed"

	dodoc AUTHORS CHANGELOG FAQ INSTALL  COPYING NEWS README* TODO
}

pkg_postinst() {
	enewgroup nofiles
	enewuser ldapdns -1 -1 /nonexistent nofiles
	enewuser dnslog -1 -1 /nonexistent nofiles

	elog "Read the readme.configure and use ldapdns-conf to setup"
}
