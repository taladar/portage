# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xkbevd/xkbevd-1.0.2.ebuild,v 1.15 2009/10/26 20:33:37 jer Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="XKB event daemon"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ~ppc64 s390 sh ~sparc x86 ~x86-fbsd"
IUSE=""
RDEPEND="x11-libs/libxkbfile"
DEPEND="${RDEPEND}"
