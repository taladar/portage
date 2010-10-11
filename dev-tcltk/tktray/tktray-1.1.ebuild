# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tktray/tktray-1.1.ebuild,v 1.5 2010/10/10 18:45:30 jlec Exp $

MY_P="${PN}${PV}"

DESCRIPTION="System Tray Icon Support for Tk on X11"
HOMEPAGE="http://sw4me.com/wiki/Tktray"
SRC_URI="http://www.sw4me.com/${MY_P}.tar.gz"

LICENSE="BWidget"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="threads debug"

DEPEND=">=dev-lang/tcl-8.4
	>=dev-lang/tk-8.4
	x11-libs/libXext"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	source /usr/lib/tclConfig.sh
	CPPFLAGS="-I${TCL_SRC_DIR}/generic ${CPPFLAGS}" \
	econf \
		$(use_enable debug symbols) \
		$(use_enable threads) \
		|| die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog
	dohtml doc/*.html
}
