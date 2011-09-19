# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/alsa-mixer/alsa-mixer-0.1.2.ebuild,v 1.1 2011/09/18 18:04:09 slyfox Exp $

# ebuild generated by hackport 0.2.13

EAPI="3"

CABAL_FEATURES="lib profile haddock hscolour"
inherit haskell-cabal

DESCRIPTION="Haskell bindings to the ALSA simple mixer API."
HOMEPAGE="http://hackage.haskell.org/package/alsa-mixer"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=dev-haskell/alsa-core-0.5*
		>=dev-lang/ghc-6.10.1
		media-libs/alsa-lib"
DEPEND="${RDEPEND}
		dev-haskell/c2hs
		>=dev-haskell/cabal-1.6"
