# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gphpedit/gphpedit-0.9.98_rc1.ebuild,v 1.3 2012/10/04 14:44:48 ago Exp $

EAPI="4"
inherit gnome2 autotools eutils

DESCRIPTION="A Gnome2 PHP/HTML source editor"
HOMEPAGE="http://www.gphpedit.org/"
SRC_URI="http://www.gphpedit.org/sites/default/files/${P/_rc/RC}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0:2
	>=dev-libs/glib-2.0:2
	gnome-base/gconf:2
	>=gnome-base/libgnomeui-2.0
	net-libs/webkit-gtk:2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog README TODO"

S="${WORKDIR}/anoopjohn-gphpedit-fe8a12c"

# Parallel build unhappy (bug #145351)
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}
