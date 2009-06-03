# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/le/le-1.14.2.ebuild,v 1.1 2009/06/02 17:47:51 truedfx Exp $

inherit base

DESCRIPTION="Terminal text editor"
HOMEPAGE="http://www.gnu.org/directory/text/editors/le-editor.html"
SRC_URI="ftp://ftp.yars.free.net/pub/source/le/le-${PV}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="virtual/libc
	>=sys-libs/ncurses-5.2-r5"
DEPEND="${RDEPEND}
	app-arch/lzma-utils"

PATCHES=( "${FILESDIR}"/${P}-gcc44.patch )

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog FEATURES HISTORY INSTALL NEWS README TODO
}
