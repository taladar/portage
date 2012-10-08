# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/text/text-0.11.1.12.ebuild,v 1.4 2012/09/12 15:01:15 qnikst Exp $

# ebuild generated by hackport 0.2.13

EAPI="3"

CABAL_FEATURES="lib profile haddock hscolour hoogle"
inherit eutils haskell-cabal

DESCRIPTION="An efficient packed Unicode text type."
HOMEPAGE="https://github.com/bos/text"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-macos"
IUSE="test"

RDEPEND=">=dev-haskell/deepseq-1.1.0.0
		>=dev-lang/ghc-6.10.1"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.10
		test? ( >=dev-haskell/quickcheck-2.4.0.1
			<dev-haskell/test-framework-0.5
			<dev-haskell/test-framework-hunit-0.3
			<dev-haskell/test-framework-quickcheck2-0.3
		)"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.11.1.6-disable-tests-that-fail-in-non-latin1-locales.patch"
}

src_configure() {
	cabal_src_configure $(use_enable test tests)
}
