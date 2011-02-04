# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libfm/libfm-0.1.15_pre20110202.ebuild,v 1.2 2011/02/03 21:01:51 hwoarang Exp $

EAPI=2

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="git://pcmanfm.git.sourceforge.net/gitroot/pcmanfm/${PN}"
	inherit autotools git
	SRC_URI=""
	EXTRA_DEPEND="dev-util/gtk-doc
		dev-util/gtk-doc-am"
else
	inherit autotools
	SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc ~x86"
fi

inherit fdo-mime

DESCRIPTION="A library for file management"
HOMEPAGE="http://pcmanfm.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug examples udev"

COMMON_DEPEND=">=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.16:2
	udev? ( dev-libs/dbus-glib )
	>=lxde-base/menu-cache-0.3.2"
RDEPEND="${COMMON_DEPEND}
	x11-misc/shared-mime-info
	udev? ( sys-fs/udisks )"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext"

src_prepare() {
	gtkdocize --copy || die
	intltoolize --force --copy --automake || die
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc \
		--disable-dependency-tracking \
		--disable-static \
		$(use_enable udev udisks) \
		$(use_enable examples demo) \
		$(use_enable debug) \
		--with-html-dir=/usr/share/doc/${PF}/html
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS TODO

	find "${D}" -name '*.la' -exec rm -f '{}' +
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
