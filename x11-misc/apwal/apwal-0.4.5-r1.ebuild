# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/apwal/apwal-0.4.5-r1.ebuild,v 1.2 2011/12/02 22:21:42 hwoarang Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="A simple application launcher and combined editor"
HOMEPAGE="http://apwal.free.fr/"
SRC_URI="http://apwal.free.fr/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/gdk-pixbuf
	dev-libs/libxml2
	dev-libs/glib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}

pkg_setup() {
	tc-export CC
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ABOUT Changelog FAQ README  || die
}
