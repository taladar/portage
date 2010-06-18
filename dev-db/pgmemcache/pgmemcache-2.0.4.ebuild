# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgmemcache/pgmemcache-2.0.4.ebuild,v 1.1 2010/06/17 17:51:41 patrick Exp $

DESCRIPTION="A PostgreSQL API based on libmemcached to interface with memcached"
HOMEPAGE="http://pgfoundry.org/projects/pgmemcache"
SRC_URI="http://pgfoundry.org/frs/download.php/2672/${PN}_${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-db/postgresql-base-8.4
	>=dev-libs/libmemcached-0.38"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README.pgmemcache NEWS || die "install documentation failed"
}
