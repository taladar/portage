# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knetworkconf/knetworkconf-4.5.3.ebuild,v 1.1 2010/11/03 16:31:03 scarabeus Exp $

EAPI="3"

KDE_HANDBOOK="optional"
KMNAME="kdeadmin"
inherit kde4-meta

DESCRIPTION="KDE control Center Module to confiure Network settings"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

src_unpack() {
	if use handbook; then
		KMEXTRA="${KMEXTRA}
			doc/kcontrol/${PN}
		"
	fi

	kde4-meta_src_unpack
}
