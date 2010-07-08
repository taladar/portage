# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/test-framework-quickcheck2/test-framework-quickcheck2-0.2.5.ebuild,v 1.2 2010/07/08 12:52:30 slyfox Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="QuickCheck2 support for the test-framework package."
HOMEPAGE="http://batterseapower.github.com/test-framework/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~x86"
IUSE=""

# works with ghc 6.8 too if we add this dependency
# >=dev-haskell/extensible-exceptions-0.1.1

RDEPEND=">=dev-lang/ghc-6.6.1
		>=dev-haskell/quickcheck-2.1.0.3
		>=dev-haskell/test-framework-0.2.0"
DEPEND=">=dev-haskell/cabal-1.2.3
		${RDEPEND}"
