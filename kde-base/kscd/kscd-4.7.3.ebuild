# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kscd/kscd-4.7.3.ebuild,v 1.3 2011/12/07 11:29:00 phajdan.jr Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdemultimedia"
inherit kde4-meta

DESCRIPTION="KDE CD player"
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkcddb)
	$(add_kdebase_dep libkcompactdisc)
	media-libs/musicbrainz:3
"
RDEPEND="${DEPEND}"

RESTRICT="test"
# bug 393099

KMEXTRACTONLY="
	libkcompactdisc/
"

src_unpack() {
	use handbook && KMEXTRA="doc/kcontrol/cddbretrieval"

	kde4-meta_src_unpack
}
