# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/tapiir/tapiir-0.7.1.ebuild,v 1.19 2009/06/01 20:13:44 ssuominen Exp $

EAPI=1
inherit eutils

DESCRIPTION="a flexible audio effects processor, inspired on the classical magnetic tape delay systems"
HOMEPAGE="http://www.iua.upf.es/~mdeboer/projects/tapiir/"
SRC_URI="ftp://www.iua.upf.es/pub/mdeboer/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="media-sound/jack-audio-connection-kit
	media-libs/alsa-lib
	x11-libs/fltk:1.1"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-gcc3.patch"
	epatch "${FILESDIR}/${P}-gcc4.patch"
	sed -i "/#include <alsa\\/asoundlib.h>/i\\#define ALSA_PCM_OLD_HW_PARAMS_API 1\\" src/alsaio.cxx
}

src_compile() {
	local myconf
	myconf="--with-fltk-prefix=/usr/$(get_libdir)/fltk-1.1 \
		--with-fltk-inc-prefix=/usr/include/fltk-1.1"
	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS
}
