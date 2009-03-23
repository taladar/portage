# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xstdcmap/xstdcmap-1.0.1.ebuild,v 1.7 2009/03/22 17:30:21 maekke Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X standard colormap utility"
KEYWORDS="~amd64 arm ~mips ~ppc ~ppc64 s390 sh ~sparc x86"
RDEPEND="x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}"
