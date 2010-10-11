# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/pfl/pfl-2.0.ebuild,v 1.7 2010/10/10 18:55:10 arfrever Exp $

EAPI="3"
PYTHON_DEPEND=2

inherit python

MY_PV=20081230

DESCRIPTION="PFL is an online searchable file/package database for Gentoo"
HOMEPAGE="http://www.portagefilelist.de/index.php/Special:PFLQuery2"
SRC_URI="http://files.portagefilelist.de/${P}
	http://files.portagefilelist.de/e-file-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="network-cron"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pyxml
	net-misc/curl
	sys-apps/portage"

RESTRICT="mirror"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_unpack() {
	cp "${DISTDIR}/${P}" "${WORKDIR}/${PN}.py"
	cp "${DISTDIR}/e-file-${MY_PV}" "${WORKDIR}/e-file"
}

src_install() {
	if use network-cron ; then
		cat >> "${T}/${PN}" <<- EOF
		#!/bin/sh
		exec nice $(PYTHON) -O $(python_get_sitedir)/${PN}/${PN}.py >/dev/null
		EOF

		exeinto /etc/cron.weekly
		doexe "${T}/${PN}" || die "install ${PN} cron file failed"
	fi

	exeinto $(python_get_sitedir)/${PN}
	doexe ${PN}.py || die "install ${PN}.py failed"

	dobin e-file || die "install e-file failed"

	dodir /var/lib/${PN} || die "directory creation failed"
}

pkg_postinst() {
	python_mod_optimize ${PN}

	if [[ ! -e "${ROOT%/}/var/lib/${PN}/pfl.info" ]]; then
		touch "${ROOT%/}/var/lib/${PN}/pfl.info"
		chown -R 0:portage "${ROOT%/}/var/lib/${PN}"
		chmod 775 "${ROOT%/}/var/lib/${PN}"
	fi
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
