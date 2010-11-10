# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/texmacs/texmacs-1.0.7.7.ebuild,v 1.2 2010/11/10 12:55:14 grozin Exp $
EAPI=2
inherit autotools
MY_P=${P/tex/TeX}-src
DESCRIPTION="Wysiwyg text processor with high-quality maths"

SRC_URI="ftp://ftp.texmacs.org/pub/TeXmacs/targz/${MY_P}.tar.gz
	ftp://ftp.texmacs.org/pub/TeXmacs/targz/TeXmacs-600dpi-fonts.tar.gz"

HOMEPAGE="http://www.texmacs.org/"
LICENSE="GPL-3"
SLOT="0"
IUSE="imlib jpeg netpbm -qt4 svg spell"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux"

RDEPEND="dev-scheme/guile[deprecated]
	virtual/latex-base
	app-text/ghostscript-gpl
	media-libs/freetype
	x11-libs/libXext
	x11-apps/xmodmap
	qt4? ( x11-libs/qt-gui:4 )
	imlib? ( media-libs/imlib2 )
	jpeg? ( || ( media-gfx/imagemagick media-gfx/jpeg2ps ) )
	svg? ( || ( media-gfx/inkscape gnome-base/librsvg ) )
	netpbm? ( media-libs/netpbm )
	spell? ( || ( >=app-text/ispell-3.2 >=app-text/aspell-0.5 ) )"

DEPEND="${RDEPEND}
	x11-proto/xproto"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use qt4; then
		ewarn "Qt port is highly experimental"
		ewarn "If you want a stable TeXmacs, emerge with USE=-qt4"
	fi
}

src_prepare() {
	# don't strip
	epatch "${FILESDIR}"/${PN}-strip.patch

	# respect LDFLAGS, bug #338459
	epatch "${FILESDIR}"/${PN}-ldflags.patch

	# CursorShape was #define'd to 0 by X11/X.h
	epatch "${FILESDIR}"/${PN}-qt.patch

	eautoreconf
}

src_configure() {
	econf $(use_with imlib imlib2) \
		--enable-optimize="${CXXFLAGS}" \
		$(use_enable qt4 qt)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc TODO || die "dodoc failed"
	domenu "${FILESDIR}"/TeXmacs.desktop || die "domenu failed"

	# now install the fonts
	insinto /usr/share/texmf
	doins -r "${WORKDIR}/fonts" || die "installing fonts failed"
}
