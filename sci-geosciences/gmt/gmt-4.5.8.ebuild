# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gmt/gmt-4.5.8.ebuild,v 1.2 2012/06/16 16:57:44 ssuominen Exp $

EAPI=4

inherit multilib autotools eutils

GSHHS="gshhs-2.2.0"

DESCRIPTION="Powerful map generator"
HOMEPAGE="http://gmt.soest.hawaii.edu/"
SRC_URI="mirror://gmt/${P}.tar.bz2
	mirror://gmt/${GSHHS}.tar.bz2
	gmttria? ( mirror://gmt/${P}-non-gpl.tar.bz2 )
"
LICENSE="GPL-2 gmttria? ( Artistic )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +gdal gmttria +metric mex +netcdf octave postscript"

RDEPEND="
	!sci-biology/probcons
	gdal? ( sci-libs/gdal )
	netcdf? ( >=sci-libs/netcdf-4.1 )
	octave? ( sci-mathematics/octave )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/GMT${PV}"

# mex can use matlab too which i can't test
REQUIRED_USE="
	mex? ( octave )
"

# hand written make files that are not parallel safe
MAKEOPTS+=" -j1"

src_prepare() {
	mv -f "${WORKDIR}/share/"* "${S}/share/" || die

	epatch \
		"${FILESDIR}/${PN}-4.5.0-no-strip.patch" \
		"${FILESDIR}/${PN}-4.5.6-respect-ldflags.patch"

	eautoreconf
}

src_configure() {
	econf \
		--libdir=/usr/$(get_libdir)/${P} \
		--includedir=/usr/include/${P} \
		--datadir=/usr/share/${P} \
		--docdir=/usr/share/doc/${PF} \
		--disable-update \
		--disable-matlab \
		--disable-xgrid \
		--enable-shared \
		--disable-debug \
		$(use_enable gdal) \
		$(use_enable netcdf) \
		$(use_enable octave) \
		$(use_enable debug devdebug) \
		$(use_enable !metric US) \
		$(use_enable postscript eps) \
		$(use_enable mex) \
		$(use_enable gmttria triangle)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		install-all

	# remove static libs
	find "${ED}/usr/$(get_libdir)" -name '*.a' -exec rm -f {} +

	dodoc README

	cat << _EOF_ > "${T}/99gmt"
GMTHOME="${EPREFIX}/usr/share/${P}"
GMT_SHAREDIR="${EPREFIX}/usr/share/${P}"
_EOF_
	doenvd "${T}/99gmt"
}
