# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xstdcmap/xstdcmap-1.0.2.ebuild,v 1.8 2011/02/12 18:38:56 armin76 Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="X standard colormap utility"
KEYWORDS="amd64 arm hppa ~mips ~ppc ppc64 s390 sh ~sparc x86"
IUSE=""
RDEPEND="x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}"
