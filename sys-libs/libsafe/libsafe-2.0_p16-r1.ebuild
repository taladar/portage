# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libsafe/libsafe-2.0_p16-r1.ebuild,v 1.5 2009/09/23 21:16:32 patrick Exp $

inherit flag-o-matic toolchain-funcs multilib

MY_P="${P/_p/-}"
DESCRIPTION="Protection against buffer overflow vulnerabilities"
HOMEPAGE="http://www.research.avayalabs.com/gcm/usa/en-us/initiatives/all/nsr.htm&Filter=ProjectTitle:Libsafe&Wrapper=LabsProjectDetails&View=LabsProjectDetails"
SRC_URI="http://www.research.avayalabs.com/project/libsafe/src/${MY_P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="prelude"

DEPEND="prelude? ( dev-libs/libprelude )"

S=${WORKDIR}/${MY_P}

src_compile() {
	local mycflags=""

	filter-flags "-fomit-frame-pointer"

	mycflags="${mycflags} ${CFLAGS}"
	mycflags="${mycflags} -DLIBSAFE_VERSION=\"\$(VERSION)\""
	use prelude && mycflags="${mycflags} \$(LIBPRELUDE_CFLAGS)"

	# Note email notification currently not implimented in this ebuild
	# due to I cannot work out if a mta is on localhost:25 for it.
	# It safer not too assume it is. Uncomment the following if desired
	# use mta && mycflags="${mycflags} -DNOTIFY_WITH_EMAIL"

	emake CC="$(tc-getCC)" CFLAGS="${mycflags}" libsafe || die
}

src_install() {
	# libsafe stuff
	into /
	dolib.so src/libsafe.so.${PV/_p/.} || die
	# dodir /lib
	dosym libsafe.so.${PV/_p/.} /$(get_libdir)/libsafe.so || die
	dosym libsafe.so.${PV/_p/.} /$(get_libdir)/libsafe.so.${PV%%.*} || die

	# Documentation
	doman doc/libsafe.8
	dohtml doc/libsafe.8.html

	dodoc COPYING README INSTALL
	use prelude && dodoc LIBPRELUDE
	# use mta && dodoc EMAIL_NOTIFICATION
}

pkg_postinst() {
	einfo
	einfo "To use this you have to put the library as one of the variables"
	einfo "in LD_PRELOAD."
	einfo "Example in bash:"
	einfo "export LD_PRELOAD=libsafe.so.${PV%%.*}"
	einfo
}
