# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkleo/libkleo-4.3.1.ebuild,v 1.3 2009/10/18 17:24:17 maekke Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="KDE library for encryption handling."
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="debug"

DEPEND="
	>=kde-base/kdepimlibs-${PV}:${SLOT}[kdeprefix=]
"
RDEPEND="${DEPEND}
	app-crypt/gnupg
"

KMSAVELIBS="true"

src_configure() {
	mycmakeargs="${mycmakeargs} -DWITH_QGPGME=ON"

	kde4-meta_src_configure
}
