# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kig/kig-4.3.3.ebuild,v 1.3 2009/11/29 17:28:17 armin76 Exp $

EAPI="2"

KMNAME="kdeedu"
inherit kde4-meta

DESCRIPTION="KDE Interactive Geometry tool"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug +handbook kig-scripting"

DEPEND="
	kig-scripting? ( >=dev-libs/boost-1.32 )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with kig-scripting BoostPython)"

	kde4-meta_src_configure
}
