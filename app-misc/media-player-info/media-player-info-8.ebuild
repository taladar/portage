# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/media-player-info/media-player-info-8.ebuild,v 1.2 2010/09/19 22:34:58 mr_bones_ Exp $

EAPI="2"

inherit base

DESCRIPTION="Repository of data files describing media player capabilities."
HOMEPAGE="http://cgit.freedesktop.org/media-player-info/"
SRC_URI="http://www.freedesktop.org/software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-fs/udev-145[extras]"
RDEPEND="${DEPEND}"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

DOCS="AUTHORS ChangeLog NEWS README"
