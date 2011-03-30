# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/uget/uget-1.5.0.3.ebuild,v 1.3 2011/03/30 11:04:19 ssuominen Exp $

EAPI="2"

inherit autotools base

DESCRIPTION="Download manager using gtk+ and libcurl"
HOMEPAGE="http://urlget.sourceforge.net/"
SRC_URI="mirror://sourceforge/urlget/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gstreamer libnotify nls"

RDEPEND="
	dev-libs/libpcre
	>=dev-libs/glib-2:2
	>=net-misc/curl-7.10
	>=x11-libs/gtk+-2.4:2
	gstreamer? ( media-libs/gstreamer )
	libnotify? ( <x11-libs/libnotify-0.7 )
	"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}"/"${PN}"-as-needed.patch
	eautoreconf
	# fix test fail
	echo "uget-gtk/ug_list_view.c" >> "${S}"/po/POTFILES.in
}

src_configure() {
	econf $(use_enable nls) \
		  $(use_enable gstreamer) \
		  $(use_enable libnotify notify) || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
