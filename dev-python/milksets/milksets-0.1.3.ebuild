# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/milksets/milksets-0.1.3.ebuild,v 1.1 2012/06/06 22:37:42 bicatali Exp $

EAPI=4

# python cruft
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Datasets in a common Pythonic interface to use with milk"
HOMEPAGE="http://luispedro.org/software/milksets"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""
