# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/killbots/killbots-4.3.1.ebuild,v 1.4 2009/10/18 16:16:01 maekke Exp $

EAPI="2"

KMNAME="kdegames"
inherit kde4-meta

DESCRIPTION="Kill the bots or they kill you!"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="debug +handbook"

# tests hang, last checked for 4.3.1
RESTRICT="test"
