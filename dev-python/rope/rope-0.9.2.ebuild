# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rope/rope-0.9.2.ebuild,v 1.2 2009/09/05 16:59:42 arfrever Exp $

EAPI="2"

NEED_PYTHON="2.5"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Python refactoring library"
HOMEPAGE="http://rope.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
RESTRICT_PYTHON_ABIS="2.4 3.*"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib:." "$(PYTHON)" ropetest/__init__.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	docinto docs
	dodoc docs/*.txt
}
