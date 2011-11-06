# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sslh/sslh-1.9.ebuild,v 1.2 2011/11/05 23:02:21 vapier Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="SSLH lets one accept both HTTPS and SSH connections on the same port"
HOMEPAGE="http://www.rutschle.net/tech/sslh.shtml"
SRC_URI="http://www.rutschle.net/tech/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="tcpd"

RDEPEND="net-libs/libnet
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
	dev-lang/perl"

src_prepare() {
	sed -i \
		-e '/strip sslh/d' \
		-e '/^LIBS=/s:$: $(LDFLAGS):' \
		-e '/^CFLAGS=/d' \
		Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		USELIBWRAP=$(usev tcpd)
}

src_install() {
	dobin sslh-{fork,select}
	dosym sslh-fork /usr/bin/sslh
	doman sslh.8.gz
	dodoc ChangeLog README

	newinitd "${FILESDIR}"/sslh.init.d sslh
	newconfd "${FILESDIR}"/sslh.conf.d sslh
}
