# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gmyth/gmyth-0.7.ebuild,v 1.9 2011/07/25 10:32:35 angelos Exp $

inherit libtool autotools eutils

IUSE="debug"
LICENSE="LGPL-2"
DESCRIPTION="GObject based library to access mythtv backends"
HOMEPAGE="http://gmyth.sourceforge.net/"
SRC_URI="mirror://sourceforge/gmyth/${PN}_${PV}-indt1.tar.gz"
KEYWORDS="amd64 ppc ~ppc64 x86"
SLOT="0"
RDEPEND="net-misc/curl
		 dev-libs/glib
		 dev-libs/libxml2
		 virtual/mysql"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-curl-headers.patch
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf   $(use_enable debug)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
