# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/p3d/p3d-0.4.3.0.ebuild,v 1.2 2011/03/11 06:48:29 jlec Exp $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils versionator

MY_P="${PN}-$(replace_version_separator 3 -)"
GITHUB_ID="gb8b9a75"

DESCRIPTION="Python module for structural bioinformatics"
HOMEPAGE="http://p3d.fufezan.net"
#SRC_URI="https://download.github.com/fu-${MY_P}-${GITHUB_ID}.tar.gz"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"
IUSE="examples"

src_prepare() {
	mv fu* ${P}
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	if use examples; then
		insinto /usr/share/${PN}
		doins -r pdbs exampleScripts
	fi
}
