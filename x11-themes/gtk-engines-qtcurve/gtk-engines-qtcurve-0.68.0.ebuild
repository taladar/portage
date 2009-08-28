# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-qtcurve/gtk-engines-qtcurve-0.68.0.ebuild,v 1.1 2009/08/27 23:27:29 wired Exp $

EAPI=1
inherit eutils cmake-utils

MY_P=${P/gtk-engines-qtcurve/QtCurve-Gtk2}

DESCRIPTION="A set of widget styles for GTK2 based apps, also available for KDE3 and Qt4"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=40492"
SRC_URI="http://home.freeuk.com/cpdrummond/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="mozilla firefox3"

RDEPEND="x11-libs/gtk+:2
	x11-libs/cairo
	firefox3? ( || ( >=www-client/mozilla-firefox-3.0
		>=www-client/mozilla-firefox-bin-3.0 ) )"
DEPEND="x11-libs/gtk+:2
	x11-libs/cairo
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}
DOCS="ChangeLog README TODO"

src_compile() {
	local mycmakeargs=""
	use mozilla && mycmakeargs="-DQTC_MODIFY_MOZILLA=true -DQTC_OLD_MOZILLA=true"
	use firefox3 && mycmakeargs="-DQTC_MODIFY_MOZILLA=true -DQTC_OLD_MOZILLA=false"
	cmake-utils_src_compile
}
