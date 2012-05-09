# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xdvik/xdvik-22.85.ebuild,v 1.3 2012/05/09 15:07:10 aballier Exp $

EAPI=4
inherit eutils flag-o-matic elisp-common toolchain-funcs

DESCRIPTION="DVI previewer for X Window System"
HOMEPAGE="http://xdvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/xdvi/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
LICENSE="GPL-2"
IUSE="motif neXt Xaw3d emacs"

RDEPEND=">=media-libs/t1lib-5.0.2
	x11-libs/libXmu
	x11-libs/libXp
	x11-libs/libXpm
	motif? ( >=x11-libs/openmotif-2.3:0 )
	!motif? ( neXt? ( x11-libs/neXtaw )
		!neXt? ( Xaw3d? ( x11-libs/libXaw3d ) ) )
	dev-libs/kpathsea"
DEPEND="sys-devel/flex
	virtual/yacc
	${RDEPEND}"
RDEPEND="${RDEPEND}
	virtual/latex-base
	!<app-text/texlive-2007"
TEXMF_PATH=/usr/share/texmf
S=${WORKDIR}/${P}/texk/xdvik

src_prepare() {
	epatch "${FILESDIR}/${P}-mksedscript.patch" \
		"${FILESDIR}/${P}-mksedscript_gentoo.patch"
	# Make sure system kpathsea headers are used
	cd "${WORKDIR}/${P}/texk/kpathsea"
	for i in *.h ; do echo "#include_next \"$i\"" > $i; done
}

src_configure() {
	local toolkit

	if use motif ; then
		toolkit="motif"
	elif use neXt ; then
		toolkit="neXtaw"
	elif use Xaw3d ; then
		toolkit="xaw3d"
	else
		toolkit="xaw"
	fi

	econf \
		--with-system-t1lib \
		--with-system-kpathsea \
		--with-kpathsea-include="${EPREFIX}"/usr/include/kpathsea \
		--with-xdvi-x-toolkit="${toolkit}"
}

src_compile() {
	emake kpathsea_dir="${EPREFIX}/usr/include/kpathsea" texmf="${EPREFIX}${TEXMF_PATH}"
	use emacs && elisp-compile xdvi-search.el
}

src_install() {
	emake DESTDIR="${D}" install

	dodir /etc/texmf/xdvi /etc/X11/app-defaults
	mv "${ED}${TEXMF_PATH}/xdvi/XDvi" "${ED}etc/X11/app-defaults" || die "failed to move config file"
	dosym {/etc/X11/app-defaults,"${TEXMF_PATH}/xdvi"}/XDvi
	for i in $(find "${ED}${TEXMF_PATH}/xdvi" -maxdepth 1 -type f) ; do
		mv ${i} "${ED}etc/texmf/xdvi" || die "failed to move $i"
		dosym {/etc/texmf,"${TEXMF_PATH}"}/xdvi/$(basename ${i})
	done

	dodoc BUGS FAQ README.*

	use emacs && elisp-install tex-utils *.el *.elc

	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry xdvi "XDVI" xdvik "Graphics;Viewer"
	echo "MimeType=application/x-dvi;" >> "${ED}"usr/share/applications/xdvi-"${PN}".desktop
}

pkg_postinst() {
	if use emacs; then
		elog "Add"
		elog "	(add-to-list 'load-path \"${EPREFIX}${SITELISP}/tex-utils\")"
		elog "	(require 'xdvi-search)"
		elog "to your ~/.emacs file"
	fi
}
