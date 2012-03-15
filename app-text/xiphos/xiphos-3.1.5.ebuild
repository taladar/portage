# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xiphos/xiphos-3.1.5.ebuild,v 1.3 2012/03/14 19:34:28 ssuominen Exp $

# TODO: waf-utils.eclass ?

EAPI=4
inherit flag-o-matic gnome2-utils python toolchain-funcs

DESCRIPTION="A bible study frontend for Sword (formerly known as GnomeSword)"
HOMEPAGE="http://xiphos.org/"
SRC_URI="mirror://sourceforge/gnomesword/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.1 LGPL-2 MIT MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbus debug webkit"

RDEPEND=">=app-text/sword-1.6.1
	>=dev-libs/glib-2
	dev-libs/libxml2
	gnome-base/gconf
	>=gnome-extra/libgsf-1.14
	x11-libs/gtk+:3
	dbus? ( dev-libs/dbus-glib )
	!webkit? ( gnome-extra/gtkhtml:4.0 )
	webkit? ( net-libs/webkit-gtk:3 )"
DEPEND="${RDEPEND}
	app-text/docbook2X
	app-text/gnome-doc-utils
	app-text/rarian
	dev-libs/libxslt
	dev-util/intltool
	dev-util/pkgconfig
	|| ( dev-lang/python:2.7 dev-lang/python:2.6 )
	sys-devel/gettext"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i \
		-e '/FLAGS_DEBUG/s:-g:-Wall:' \
		-e '/FLAGS_RELEASE/s:-O2:-Wall:' \
		wscript || die
}

src_configure() {
	append-cppflags -DNO_SWORD_SET_RENDER_NOTE_NUMBERS=1

	tc-export AR CC CPP CXX RANLIB

	local backend=gtkhtml
	use webkit && backend=webkit

	CCFLAGS="${CFLAGS}" \
	LINKFLAGS="${LDFLAGS}" \
	SGML2MAN="$(type -P docbook2man.pl)" \
		./waf -v \
			--prefix=/usr \
			--gtk=3 \
			--backend=${backend} \
			--debug-level=$(use debug && echo debug || echo release) \
			$(use dbus || echo --disable-dbus) \
			configure || die
}

src_compile() {
	./waf -v build || die
}

src_install() {
	./waf -v --destdir="${D}" install || die

	doman ${PN}.1
	dodoc AUTHORS ChangeLog NEWS README RELEASE-NOTES TODO

	dodoc Xiphos.ogg
	docompress -x /usr/share/doc/${PF}/Xiphos.ogg

	rm -rf "${ED}"/usr/share/doc/${PN}
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
