# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmousetool/kmousetool-4.3.5.ebuild,v 1.2 2010/02/20 11:12:23 ssuominen Exp $

EAPI="2"

KMNAME="kdeaccessibility"

inherit kde4-meta

DESCRIPTION="KDE program that clicks the mouse for you."
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook"

RDEPEND="$(add_kdebase_dep knotify)"
