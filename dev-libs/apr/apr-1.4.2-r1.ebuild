# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr/apr-1.4.2-r1.ebuild,v 1.1 2011/02/18 17:02:48 hollow Exp $

EAPI="2"

inherit autotools eutils libtool multilib

DESCRIPTION="Apache Portable Runtime Library"
HOMEPAGE="http://apr.apache.org/"
SRC_URI="mirror://apache/apr/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="doc older-kernels-compatibility +urandom +uuid elibc_FreeBSD"
RESTRICT="test"

RDEPEND="
	uuid? (
		!elibc_FreeBSD? (
			|| ( >=sys-apps/util-linux-2.16 <sys-libs/e2fsprogs-libs-1.41.8 )
		)
	)
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	# Ensure that system libtool is used.
	sed -e 's:${installbuilddir}/libtool:/usr/bin/libtool:' -i apr-config.in || die "sed failed"
	sed -e 's:@LIBTOOL@:$(SHELL) /usr/bin/libtool:' -i build/apr_rules.mk.in || die "sed failed"

	AT_M4DIR="build" eautoreconf
	elibtoolize

	epatch "${FILESDIR}/config.layout.patch"
	epatch "${FILESDIR}/apr_ring_volatile.patch"
}

src_configure() {
	local myconf

	if use older-kernels-compatibility; then
		local apr_cv_accept4 apr_cv_dup3 apr_cv_epoll_create1 apr_cv_sock_cloexec
		export apr_cv_accept4="no"
		export apr_cv_dup3="no"
		export apr_cv_epoll_create1="no"
		export apr_cv_sock_cloexec="no"
	fi

	use uuid || export apr_cv_osuuid=no

	if use urandom; then
		myconf+=" --with-devrandom=/dev/urandom"
	else
		myconf+=" --with-devrandom=/dev/random"
	fi

	CONFIG_SHELL=/bin/bash \
	econf --enable-layout=gentoo \
		--enable-nonportable-atomics \
		--enable-threads \
		${myconf}

	rm -f libtool
}

src_compile() {
	emake -j1 || die "emake failed"

	if use doc; then
		emake dox || die "emake dox failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc CHANGES NOTICE README

	if use doc; then
		dohtml -r docs/dox/html/* || die "dohtml failed"
	fi

	# This file is only used on AIX systems, which Gentoo is not,
	# and causes collisions between the SLOTs, so remove it.
	rm -f "${D}usr/$(get_libdir)/apr.exp"
}
