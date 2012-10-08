# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/x11/x11-1.5.0.0-r1.ebuild,v 1.3 2012/09/12 14:44:14 qnikst Exp $

# ebuild generated by hackport 0.2.13

EAPI="3"

CABAL_FEATURES="lib profile haddock hscolour"
inherit haskell-cabal

MY_PN="X11"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A binding to the X11 graphics library"
HOMEPAGE="http://code.haskell.org/X11"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 ~amd64-linux ~ppc64 ~ppc-macos ~x86-linux"
IUSE="+xinerama"

RDEPEND="dev-haskell/syb[profile?]
		>=dev-lang/ghc-6.8.2
		x11-libs/libX11
		xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"

S="${WORKDIR}/${MY_P}"

src_configure() {
	cabal_src_configure --configure-option=$(use_with xinerama)
}
