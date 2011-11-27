# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nb/nb-0.8.3.ebuild,v 1.5 2011/11/27 04:29:59 radhermit Exp $

EAPI="3"

inherit autotools autotools-utils eutils

DESCRIPTION="Nodebrain is a tool to monitor and do event correlation."
HOMEPAGE="http://nodebrain.sourceforge.net/"
SRC_URI="mirror://sourceforge/nodebrain/nodebrain-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="static-libs"

DEPEND="
	dev-lang/perl
	dev-util/pkgconfig
	sys-apps/texinfo
"
RDEPEND="
	!sys-boot/netboot
	!www-apps/nanoblogger
"

AUTOTOOLS_IN_SOURCE_BUILD=1

S="${WORKDIR}/nodebrain-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure.patch

	# fdl.texi is not included in the sources
	sed -i doc/nbTutorial/nbTutorial.texi -e '/@include fdl.texi/d' || die

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static) --include=/usr/include
}

src_compile() {
	# Fails at parallel make
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	use static-libs || remove_libtool_files
	dodoc AUTHORS NEWS README THANKS sample/*
	dohtml html/*
}
