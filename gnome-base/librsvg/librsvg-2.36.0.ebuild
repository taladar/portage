# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/librsvg/librsvg-2.36.0.ebuild,v 1.1 2012/04/12 02:49:02 tetromino Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit autotools eutils gnome2 multilib

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="http://librsvg.sourceforge.net/"
SRC_URI="${SRC_URI} mirror://gentoo/introspection.m4.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc +gtk +introspection tools"

RDEPEND=">=dev-libs/glib-2.24:2
	>=x11-libs/cairo-1.2
	>=x11-libs/pango-1.16
	>=dev-libs/libxml2-2.7:2
	>=dev-libs/libcroco-0.6.1
	x11-libs/gdk-pixbuf:2[introspection?]
	gtk? (
		>=x11-libs/gtk+-2.16:2
		tools? ( >=x11-libs/gtk+-3:3 ) )
	introspection? ( >=dev-libs/gobject-introspection-0.10.8 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12
	doc? ( >=dev-util/gtk-doc-1.13 )

	dev-libs/gobject-introspection-common
	>=dev-util/gtk-doc-am-1.13"
# >=gtk-doc-am-1.13 and gobject-introspection-common needed by eautoreconf

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable tools)
		$(use_enable gtk gtk-theme)
		$(use_enable introspection)
		--enable-pixbuf-loader"
	if use gtk && use tools; then
		G2CONF="${G2CONF} --enable-rsvg-view"
	else
		G2CONF="${G2CONF} --disable-rsvg-view"
	fi

	DOCS="AUTHORS ChangeLog README NEWS TODO"
}

src_prepare() {
	# Fix man page
	mv rsvg.1 rsvg-convert.1 || die "mv failed"
	epatch "${FILESDIR}/${P}-rsvg-convert.1.patch"

	# Make rsvg-view non-automagic
	epatch "${FILESDIR}/${P}-rsvg-view-automagic.patch"

	eautoreconf
	gnome2_src_prepare
}

pkg_postinst() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER

	tmp_file=$(mktemp --suffix=gdk_pixbuf_ebuild)
	# be atomic!
	gdk-pixbuf-query-loaders > "${tmp_file}"
	if [ "${?}" = "0" ]; then
		cat "${tmp_file}" > "${EROOT}usr/$(get_libdir)/gdk-pixbuf-2.0/2.10.0/loaders.cache"
	else
		ewarn "Cannot update loaders.cache, gdk-pixbuf-query-loaders failed to run"
	fi
	rm "${tmp_file}"
}

pkg_postrm() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER

	tmp_file=$(mktemp --suffix=gdk_pixbuf_ebuild)
	# be atomic!
	gdk-pixbuf-query-loaders > "${tmp_file}"
	if [ "${?}" = "0" ]; then
		cat "${tmp_file}" > "${EROOT}usr/$(get_libdir)/gdk-pixbuf-2.0/2.10.0/loaders.cache"
	else
		ewarn "Cannot update loaders.cache, gdk-pixbuf-query-loaders failed to run"
	fi
	rm "${tmp_file}"
}
