# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/maq/maq-0.7.1-r1.ebuild,v 1.1 2011/04/14 07:46:27 jlec Exp $

EAPI="4"

inherit autotools eutils

DESCRIPTION="Mapping and Assembly with Qualities - mapping Solexa and SOLiD reads to reference sequences"
HOMEPAGE="http://maq.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/calib-36.dat.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch \
	"${FILESDIR}"/${P}-flags.patch \
	"${FILESDIR}"/${P}-bfr-overfl.patch
	eautoreconf
}

src_install() {
	default
	insinto /usr/share/maq
	doins "${WORKDIR}"/*.dat || die
	doman maq.1
	dodoc ${PN}.pdf
}
