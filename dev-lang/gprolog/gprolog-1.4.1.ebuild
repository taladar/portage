# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/gprolog/gprolog-1.4.1.ebuild,v 1.4 2012/10/04 15:15:16 ottxor Exp $

EAPI=4

inherit eutils flag-o-matic multilib

DESCRIPTION="GNU Prolog is a native Prolog compiler with constraint solving over finite domains (FD)"
HOMEPAGE="http://www.gprolog.org/"
SRC_URI="mirror://gnu/gprolog/${P}.tar.gz"
S="${WORKDIR}"/${P}

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="debug doc examples"

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}-links.patch
	epatch "${FILESDIR}"/${P}-nodocs.patch
	epatch "${FILESDIR}"/${P}-txt-file.patch
}

src_configure() {
	CFLAGS_MACHINE="`get-flag -march` `get-flag -mcpu` `get-flag -mtune`"

	append-flags -fno-strict-aliasing
	use debug && append-flags -DDEBUG

	if gcc-specs-pie ; then
		# gplc generates its own native ASM; disable PIE
		append-ldflags -nopie
	fi

	cd "${S}"/src
	econf \
		CFLAGS_MACHINE="${CFLAGS_MACHINE}" \
		--with-c-flags="${CFLAGS}" \
		--with-install-dir=/usr/$(get_libdir)/${P} \
		--with-links-dir=/usr/bin \
		$(use_with doc doc-dir /usr/share/doc/${PF}) \
		$(use_with doc html-dir /usr/share/doc/${PF}/html) \
		$(use_with examples examples-dir /usr/share/doc/${PF}/examples)
}

src_compile() {
	cd "${S}"/src
	emake
}

src_test() {
	cd "${S}"/src
	emake check
}

src_install() {
	cd "${S}"/src
	emake DESTDIR="${D}" install

	cd "${S}"
	dodoc ChangeLog NEWS PROBLEMS README VERSION
}
