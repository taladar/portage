# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/editline/editline-0.2.1.0.ebuild,v 1.2 2012/09/12 15:04:50 qnikst Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Bindings to the editline library (libedit)."
HOMEPAGE="http://code.haskell.org/editline"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.6.1
		dev-libs/libedit"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"
