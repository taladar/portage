# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/elfix/elfix-0.2.0.ebuild,v 1.1 2011/09/18 23:48:48 blueness Exp $

EAPI=4

DESCRIPTION="Tool to query or clear the ELF GNU_STACK executable flag"
HOMEPAGE="http://dev.gentoo.org/~blueness/elfix/"
SRC_URI="http://dev.gentoo.org/~blueness/elfix/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-libs/elfutils
	test? ( dev-lang/yasm )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable test tests)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog INSTALL README THANKS TODO
}
