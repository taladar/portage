# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/scrub/scrub-2.4.1.ebuild,v 1.2 2012/02/16 11:59:32 ago Exp $

EAPI="3"

DESCRIPTION="write patterns on disk/file"
HOMEPAGE="http://code.google.com/p/diskscrub/"
SRC_URI="http://diskscrub.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
