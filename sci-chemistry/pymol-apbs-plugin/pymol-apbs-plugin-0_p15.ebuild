# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pymol-apbs-plugin/pymol-apbs-plugin-0_p15.ebuild,v 1.1 2010/02/11 20:26:16 jlec Exp $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"

inherit python

MY_PV="${PV##*_p}"

DESCRIPTION="APBS plugin for pymol"
HOMEPAGE="http://sourceforge.net/projects/pymolapbsplugin/"
SRC_URI="http://pymolapbsplugin.svn.sourceforge.net/viewvc/pymolapbsplugin/trunk/src/apbsplugin.py?revision=${MY_PV} -> ${P}.py"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="pymol"
IUSE=""

RDEPEND="
	sci-chemistry/apbs
	sci-chemistry/pdb2pqr
	!<sci-chemistry/pymol-1.2.2-r1"
DEPEND="${RDEPEND}"

src_unpack() {
	mkdir "${S}"
	cp "${DISTDIR}"/${P}.py "${S}"/
	python_copy_sources --no-link
}

src_install() {
	installation() {
		sed \
			-e "s:^APBS_BINARY_LOCATION.*:APBS_BINARY_LOCATION = \"${EPREFIX}/usr/bin/apbs\":g" \
			-e "s:^APBS_PSIZE_LOCATION.*:APBS_PSIZE_LOCATION = \"${EPREFIX}/$(python_get_sitedir)/pdb2pqr/src/\":g" \
			-e "s:^APBS_PDB2PQR_LOCATION.*:APBS_PDB2PQR_LOCATION = \"${EPREFIX}/$(python_get_sitedir)/pdb2pqr/\":g" \
			-e "s:^TEMPORARY_FILE_DIR.*:TEMPORARY_FILE_DIR = \"./\":g" \
			-i ${P}.py

		insinto $(python_get_sitedir)/pmg_tk/startup/
		newins ${P}.py apbs_tools.py || die
	}
	python_execute_function -s installation
}

pkg_postinst() {
	python_mod_optimize pmg_tk/startup/apbs_tools.py
}

pkg_postrm() {
	python_mod_cleanup pmg_tk/startup/apbs_tools.py
}
