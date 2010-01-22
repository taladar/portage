# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Daemon/Net-Daemon-0.43.ebuild,v 1.13 2010/01/21 12:34:16 tove Exp $

EAPI=2

MODULE_SECTION=${PN}
MODULE_AUTHOR=MNOONING
inherit perl-module

DESCRIPTION="Abstract base class for portable servers"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

S=${WORKDIR}/${PN}
