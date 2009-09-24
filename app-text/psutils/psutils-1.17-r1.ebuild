# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/psutils/psutils-1.17-r1.ebuild,v 1.2 2009/09/23 16:37:48 patrick Exp $

inherit toolchain-funcs eutils

DESCRIPTION="PostScript Utilities"
HOMEPAGE="http://www.tardis.ed.ac.uk/~ajcd/psutils"
SRC_URI="ftp://ftp.enst.fr/pub/unix/a2ps/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-lang/perl"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-ldflags.patch"
	sed \
		-e "s:/usr/local:\$(DESTDIR)/usr:" \
		"${S}/Makefile.unix" > "${S}/Makefile"
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install () {
	dodir /usr/{bin,share/man}
	emake DESTDIR="${D}" install || die
	dodoc README
}
