# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/lklug/lklug-0.5.4.ebuild,v 1.2 2012/02/18 14:30:31 phajdan.jr Exp $

EAPI="4"

inherit font

MY_P="ttf-sinhala-${P}"
DESCRIPTION="Sinhala font"
HOMEPAGE="http://sinhala.sourceforge.net"
SRC_URI="http://sinhala.sourceforge.net/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"

FONT_SUFFIX="ttf"

DOCS="README.fonts"
