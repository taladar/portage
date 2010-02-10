# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/autoconf-archive/autoconf-archive-2009.12.16.ebuild,v 1.1 2010/02/09 07:46:18 pva Exp $

EAPI="2"

DESCRIPTION="GNU Autoconf Macro Archive"
HOMEPAGE="http://autoconf-archive.cryp.to/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die
	# Put documentation into correct location
	dodir /usr/share/doc
	mv "${D}"/usr/share/{${PN},doc/${PF}} || die
}
