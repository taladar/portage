# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/pms/pms-3.ebuild,v 1.3 2010/02/09 14:50:22 fauli Exp $

EAPI=2

DESCRIPTION="Gentoo Package Manager Specification"
HOMEPAGE="http://www.gentoo.org/proj/en/qa/pms.xml"
SRC_URI="mirror://gentoo/pms-${PV}.pdf"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="3"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~mips-irix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~x86-netbsd ~ppc-openbsd ~x64-openbsd ~x86-openbsd ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	:
}

src_install() {
	dodoc "${DISTDIR}"/pms-${PV}.pdf || die
}
