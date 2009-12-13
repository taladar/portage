# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/patchage/patchage-0.4.4.ebuild,v 1.1 2009/12/12 18:44:51 aballier Exp $

EAPI=2

inherit toolchain-funcs eutils

DESCRIPTION="Modular patch bay for audio and MIDI systems"
HOMEPAGE="http://wiki.drobilla.net/Patchage"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug lash"

RDEPEND=">=media-libs/raul-0.5.1
	>=x11-libs/flowcanvas-0.5.1
	>=dev-cpp/gtkmm-2.11.12
	dev-cpp/glibmm
	dev-cpp/libglademm
	dev-cpp/libgnomecanvasmm
	dev-libs/boost
	>=media-sound/jack-audio-connection-kit-0.107
	alsa? ( media-libs/alsa-lib )
	lash? ( dev-libs/dbus-glib )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/ldconfig.patch"
}

src_configure() {
	tc-export CC CXX CPP AR RANLIB
	./waf configure \
		--prefix=/usr \
		$(use debug && echo "--debug") \
		$(use alsa || echo "--no-alsa") \
		$(use lash || echo "--no-lash") \
		|| die
}

src_compile() {
	./waf || die
}

src_install() {
	./waf install --destdir="${D}" || die
	dodoc AUTHORS README ChangeLog
}
