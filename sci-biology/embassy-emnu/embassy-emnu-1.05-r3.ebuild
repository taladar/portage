# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-emnu/embassy-emnu-1.05-r3.ebuild,v 1.7 2011/03/13 12:55:32 armin76 Exp $

EBOV="4.0.0"

inherit embassy

DESCRIPTION="EMBOSS Menu is Not UNIX - Simple menu of EMBOSS applications"
SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-${EBOV}.tar.gz
	mirror://gentoo/embassy-${EBOV}-${PN:8}-${PV}.tar.gz"

KEYWORDS="~amd64 ppc x86"

RDEPEND="sys-libs/ncurses
	${RDEPEND}"

DEPEND="sys-libs/ncurses
	${DEPEND}"
