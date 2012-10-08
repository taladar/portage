# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hsql-odbc/hsql-odbc-1.8.1.1.ebuild,v 1.3 2012/09/12 14:43:09 qnikst Exp $

# ebuild generated by hackport 0.2.13

EAPI=4

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="A Haskell Interface to ODBC."
HOMEPAGE="http://hackage.haskell.org/package/hsql-odbc"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-haskell/hsql-1.8[profile?]
		>=dev-lang/ghc-6.10.1
		>=dev-db/unixODBC-2.2"
DEPEND="${RDEPEND}
		dev-haskell/cabal"
