# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xclip/xclip-0.12.ebuild,v 1.2 2009/10/18 12:41:05 ssuominen Exp $

DESCRIPTION="Command-line utility to read data from standard in and place it in an X selection"
HOMEPAGE="http://sourceforge.net/projects/xclip/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXmu"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README
}
