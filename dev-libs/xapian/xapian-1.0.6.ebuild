# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xapian/xapian-1.0.6.ebuild,v 1.4 2009/09/23 16:53:42 patrick Exp $

DESCRIPTION="Xapian Probabilistic Information Retrieval library"
HOMEPAGE="http://www.xapian.org/"
SRC_URI="http://www.oligarchy.co.uk/xapian/${PV}/xapian-core-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="sys-apps/gawk
	sys-apps/grep
	sys-apps/sed
	sys-devel/libtool
	sys-devel/gcc"

RDEPEND=""

S=${WORKDIR}/xapian-core-${PV}

src_install () {
	emake DESTDIR="${D}" install || die

	mv "${D}/usr/share/doc/xapian-core" "${D}/usr/share/doc/${PF}"

	dodoc AUTHORS HACKING PLATFORMS README NEWS || die "dodoc failed"
}
