# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/rpc2/rpc2-2.0.ebuild,v 1.4 2010/05/08 17:32:50 george Exp $

DESCRIPTION="Remote procedure call package for IP/UDP (used by Coda)"
HOMEPAGE="http://www.coda.cs.cmu.edu/"
SRC_URI="http://www.coda.cs.cmu.edu/pub/rpc2/src/${P}.tar.gz"
IUSE=""
SLOT="1"
LICENSE="LGPL-2.1"
KEYWORDS="~alpha ~amd64 ~hppa ia64 ~mips ~ppc ~sparc x86"

RDEPEND=">=sys-libs/lwp-2.1"

DEPEND="${RDEPEND}
	sys-apps/gawk
	sys-apps/sed
	sys-apps/grep
	sys-devel/libtool"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc NEWS README.ipv6
}
