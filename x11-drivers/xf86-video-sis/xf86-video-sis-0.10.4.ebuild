# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-sis/xf86-video-sis-0.10.4.ebuild,v 1.1 2012/03/24 16:29:11 chithanh Exp $

EAPI=4
XORG_DRI=dri
inherit xorg-2

DESCRIPTION="SiS and XGI video driver"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86 ~x86-fbsd"
IUSE="dri"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS="$(use_enable dri)"
}
