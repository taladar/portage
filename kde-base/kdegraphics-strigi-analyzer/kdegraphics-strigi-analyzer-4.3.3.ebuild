# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegraphics-strigi-analyzer/kdegraphics-strigi-analyzer-4.3.3.ebuild,v 1.3 2009/11/29 17:48:15 armin76 Exp $

EAPI="2"

KMNAME="kdegraphics"
KMMODULE="strigi-analyzer"
inherit kde4-meta

DESCRIPTION="kdegraphics: strigi plugins"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

KMEXTRACTONLY="libs/mobipocket"
