# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krdc/krdc-4.3.5.ebuild,v 1.2 2010/02/20 11:25:56 ssuominen Exp $

EAPI="2"

KMNAME="kdenetwork"
inherit kde4-meta

DESCRIPTION="KDE remote desktop connection (RDP and VNC) client"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook jpeg rdp vnc zeroconf"

DEPEND="
	jpeg? ( media-libs/jpeg )
	vnc? ( >=net-libs/libvncserver-0.9 )
	zeroconf? (
		|| (
			net-dns/avahi
			net-misc/mDNSResponder
		)
	)
"
RDEPEND="${DEPEND}
	rdp? ( net-misc/rdesktop )
"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with vnc LibVNCServer)
		$(cmake-utils_use_with zeroconf DNSSD)
	)

	kde4-meta_src_configure
}
