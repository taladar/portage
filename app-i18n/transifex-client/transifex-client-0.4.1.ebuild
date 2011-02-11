# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/transifex-client/transifex-client-0.4.1.ebuild,v 1.1 2011/02/11 00:05:48 hwoarang Exp $

EAPI=3
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="A command line interface for Transifex"
HOMEPAGE="http://http://pypi.python.org/pypi/transifex-client/0.4.1 http://www.transifex.net/ -"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
