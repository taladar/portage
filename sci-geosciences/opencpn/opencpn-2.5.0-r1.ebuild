# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/opencpn/opencpn-2.5.0-r1.ebuild,v 1.1 2011/12/02 16:39:38 mschiff Exp $

EAPI=4

WX_GTK_VER="2.8"
MY_P=OpenCPN-${PV}-Source
inherit cmake-utils wxwidgets

DESCRIPTION="a free, open source software for marine navigation"
HOMEPAGE="http://opencpn.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gps"

RDEPEND="
	app-arch/bzip2
	dev-libs/tinyxml
	media-libs/freetype:2
	sys-libs/zlib
	virtual/opengl
	x11-libs/gtk+:2
	>=x11-libs/wxGTK-2.8.11.0[X]
	gps? ( >=sci-geosciences/gpsd-2.95 )
"
DEPEND="${DEPEND}
	sys-devel/gettext"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-multilib-strict.patch"
	"${FILESDIR}/${P}_tinyxml_stl.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use gps GPSD)
		-DUSE_S57=ON
		-DUSE_GARMINHOST=ON
		-DUSE_WIFI_CLIENT=OFF
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	if grep -rqE "sci-geosciences/opencpn.*gpsd" /etc/make.conf /etc/portage/package.use*; then
		if use gps; then
			ewarn "The local 'gpsd' USE flag has been removed in favour of the"
			ewarn "global 'gps' USE flag which is enabled on your system."
			ewarn ""
			ewarn "Please remove the 'gpsd' USE flag from your make.conf"
			ewarn "and/or /etc/portage/package.use files."
		else
			ewarn "global 'gps' USE flag."
			ewarn ""
			ewarn "In order to have GPS support in OpenCPN you need to"
			ewarn "enable the 'gps' USE flag."
		fi
	fi
}
