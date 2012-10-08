# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/gtk/gtk-0.12.0.ebuild,v 1.4 2012/09/12 14:39:44 qnikst Exp $

# ebuild generated by hackport 0.2.13

EAPI="3"

#nocabaldep is for the fancy cabal-detection feature at build-time
CABAL_FEATURES="lib profile haddock hscolour nocabaldep"
inherit haskell-cabal

DESCRIPTION="Haskell bindings to the Gtk+ graphical user interface library."
HOMEPAGE="http://www.haskell.org/gtk2hs/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+gio"

RDEPEND="=dev-haskell/cairo-0.12*
		=dev-haskell/glib-0.12*
		dev-haskell/mtl
		=dev-haskell/pango-0.12*
		>=dev-lang/ghc-6.10.1
		dev-libs/glib:2
		x11-libs/gtk+:2
		gio? ( =dev-haskell/gio-0.12* )"
DEPEND="${RDEPEND}
		dev-haskell/gtk2hs-buildtools"

src_configure() {
	# Upstream has this enabled, so we might as well force it enabled to be sure.
	cabal_src_configure \
		--flags=deprecated \
		$(cabal_flag gio have-gio)
}
