# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvisio/libvisio-9999.ebuild,v 1.2 2011/08/10 08:59:17 scarabeus Exp $

EAPI=4

EGIT_REPO_URI="git://anongit.freedesktop.org/git/libreoffice/contrib/libvisio/"
[[ ${PV} == 9999 ]] && vcs=git-2
inherit autotools ${vcs}
unset vcs

DESCRIPTION="Library parsing the visio documents"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/libvisio"
[[ ${PV} == 9999 ]] || SRC_URI="http://cgit.freedesktop.org/libreoffice/contrib/${PN}/snapshot/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
[[ ${PV} == 9999 ]] || KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	app-text/libwpd:0.9
	app-text/libwpg:0.2
"
DEPEND="${DEPEND}
	sys-devel/libtool
	doc? ( app-doc/doxygen )
"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--disable-werror \
		$(use_with doc docs)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
