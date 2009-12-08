# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/solid/solid-4.3.4-r1.ebuild,v 1.1 2009/12/07 15:34:47 ssuominen Exp $

EAPI="2"

KMNAME="kdebase-workspace"
CPPUNIT_REQUIRED="test"
inherit kde4-meta

DESCRIPTION="Solid: the KDE hardware library"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="bluetooth debug networkmanager wicd"

# solid/CMakeLists.txt has an add_subdirectory statement that depends on
# networkmanager-0.7, referring to a non-existant directory, restricted to =0.6*
# for now.
DEPEND="
	>=sys-apps/hal-0.5.9
	bluetooth? ( net-wireless/bluez )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	wicd? ( net-misc/wicd )
"
RDEPEND="${DEPEND}"

KMEXTRA="
	libs/solid/
"

PATCHES=( "${FILESDIR}/${P}-hal.patch" )

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with bluetooth BlueZ)
		$(cmake-utils_use_with networkmanager NetworkManager)
		$(cmake-utils_use_build wicd)
	"

	kde4-meta_src_configure
}
