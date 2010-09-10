# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/podofo/podofo-0.8.2.ebuild,v 1.1 2010/09/10 06:37:37 zmedico Exp $

EAPI=2
inherit cmake-utils multilib

DESCRIPTION="PoDoFo is a C++ library to work with the PDF file format."
HOMEPAGE="http://sourceforge.net/projects/podofo/"
SRC_URI="mirror://sourceforge/podofo/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="+boost debug test"

RDEPEND="dev-lang/lua
	dev-libs/openssl
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/jpeg:0
	media-libs/libpng
	media-libs/tiff
	sys-libs/zlib"
DEPEND="${RDEPEND}
	boost? ( dev-util/boost-build )
	test? ( dev-util/cppunit )"

DOCS="AUTHORS ChangeLog TODO"

src_prepare() {
	sed -i \
		-e "s:LIBDIRNAME \"lib\":LIBDIRNAME \"$(get_libdir)\":" \
		CMakeLists.txt || die
}

src_configure() {
	mycmakeargs+=(
		"-DPODOFO_BUILD_SHARED=1"
		"-DPODOFO_HAVE_JPEG_LIB=1"
		"-DPODOFO_HAVE_PNG_LIB=1"
		"-DPODOFO_HAVE_TIFF_LIB=1"
		"-DWANT_FONTCONFIG=1"
		"-DUSE_STLPORT=0"
		$(cmake-utils_use_want boost)
		$(cmake-utils_use_has test CPPUNIT)
		)

	cmake-utils_src_configure
}
