# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmahjongg/kmahjongg-4.7.3.ebuild,v 1.2 2011/12/07 11:12:06 phajdan.jr Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdegames"
inherit kde4-meta

DESCRIPTION="Mahjongg for KDE"
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkmahjongg)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libkdegames/
	libkmahjongg/
"
