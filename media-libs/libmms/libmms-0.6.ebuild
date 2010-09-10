# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmms/libmms-0.6.ebuild,v 1.2 2010/09/10 12:35:28 ssuominen Exp $

EAPI=2

DESCRIPTION="Common library for accessing Microsoft Media Server (MMS) media streaming protocol"
HOMEPAGE="http://sourceforge.net/projects/libmms/ http://launchpad.net/libmms/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="static-libs"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README TODO
	find "${D}" -name '*.la' -exec rm -f '{}' +
}
