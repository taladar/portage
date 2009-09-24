# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libtlen/libtlen-20060309.ebuild,v 1.8 2009/09/23 18:50:31 patrick Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils autotools

DESCRIPTION="Support library for Tlen IMS"
HOMEPAGE="http://tleenx.sourceforge.net/"
SRC_URI="mirror://sourceforge/tleenx/${P}.tar.gz"

KEYWORDS="~alpha amd64 ~ia64 ~mips ppc sparc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}

	if use amd64; then
		epatch ${FILESDIR}/20040912-fPIC.patch
	fi

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf \
		--enable-shared || die
	emake all || die
}

src_install() {
	einstall || die
	dodoc ChangeLog
}
