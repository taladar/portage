# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/umbrello/umbrello-4.7.3.ebuild,v 1.2 2011/12/07 12:12:18 phajdan.jr Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdesdk"

inherit kde4-meta

DESCRIPTION="KDE UML Modeller"
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
