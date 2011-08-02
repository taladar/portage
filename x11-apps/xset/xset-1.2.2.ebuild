# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xset/xset-1.2.2.ebuild,v 1.1 2011/08/01 21:15:53 chithanh Exp $

EAPI=4

inherit xorg-2

DESCRIPTION="X.Org xset application"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXext"
DEPEND="${RDEPEND}"

pkg_setup() {
	CONFIGURE_OPTIONS="--without-xf86misc --without-fontcache"
	xorg-2_pkg_setup
}
