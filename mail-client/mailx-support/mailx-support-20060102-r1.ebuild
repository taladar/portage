# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mailx-support/mailx-support-20060102-r1.ebuild,v 1.15 2010/09/30 07:29:06 grobian Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Provides lockspool utility"
HOMEPAGE="http://www.openbsd.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-respect-ldflags.patch

	# This code should only be ran with Gentoo Prefix profiles
	if use prefix; then
		ebegin "Allowing unprivileged install"
		sed -i -e "s|-g 0 -o 0||g" Makefile
		eend $?
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" BINDNOW_FLAGS="" || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
}
