# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/jinja/jinja-2.5.2.ebuild,v 1.6 2010/10/08 06:46:32 leio Exp $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

MY_PN="Jinja2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A small but fast and easy to use stand-alone template engine written in pure python."
HOMEPAGE="http://jinja.pocoo.org/ http://pypi.python.org/pypi/Jinja2"
SRC_URI="mirror://pypi/J/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc examples i18n test"

RDEPEND="dev-python/setuptools
	dev-python/markupsafe
	i18n? ( >=dev-python/Babel-0.9.3 )"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-0.6 )"

S="${WORKDIR}/${MY_P}"

DISTUTILS_GLOBAL_OPTIONS=("--with-debugsupport")
DOCS="CHANGES"
PYTHON_MODNAME="jinja2"

src_prepare() {
	distutils_src_prepare
	find examples -name "*.py[co]" -print0 | xargs -0 rm -f
}

src_compile(){
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		cd docs
		PYTHONPATH=".." emake html || die "Building of documentation failed"
	fi
}

src_install(){
	distutils_src_install
	python_clean_installation_image

	if use doc; then
		dohtml -r docs/_build/html/* || die "Installation of documentation failed"
	fi

	if use examples; then
		insinto "/usr/share/doc/${PF}"
		doins -r examples || die "Failed to install examples"
	fi
}
