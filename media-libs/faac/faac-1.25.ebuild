# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/faac/faac-1.25.ebuild,v 1.9 2009/07/10 19:42:29 ssuominen Exp $

inherit libtool eutils autotools flag-o-matic

DESCRIPTION="Free MPEG-4 audio codecs by AudioCoding.com"
HOMEPAGE="http://www.audiocoding.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""
RDEPEND=">=media-libs/libsndfile-1.0.0
	<media-libs/libmp4v2-1.9.0"
DEPEND="${RDEPEND}
	!<media-libs/faad2-2.0-r3"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-external-libmp4v2.patch

	sed -i -e "s/.$//" configure.in

	eautoreconf
	elibtoolize
	epunt_cxx
}

src_compile() {
	filter-flags -ftree-vectorize

	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README TODO docs/libfaac.pdf
	dohtml docs/*
}
