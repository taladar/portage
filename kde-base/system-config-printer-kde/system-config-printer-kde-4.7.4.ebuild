# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/system-config-printer-kde/system-config-printer-kde-4.7.4.ebuild,v 1.4 2012/02/18 16:29:39 nixnut Exp $

EAPI=4

KMNAME="kdeadmin"
PYTHON_DEPEND="2"
inherit python kde4-meta

DESCRIPTION="KDE port of Red Hat's Gnome system-config-printer"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

DEPEND="
	>=app-admin/system-config-printer-common-1.2.2
	>=dev-python/pycups-1.9.49
	$(add_kdebase_dep pykde4)
"
RDEPEND="${DEPEND}
	net-print/cups[dbus]
"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	kde4-meta_pkg_setup
}

src_install() {
	kde4-meta_src_install
	python_convert_shebangs -q -r $(python_get_version) "${ED}"
}

pkg_postrm() {
	python_mod_cleanup "${PREFIX}share/apps/${PN}"
}
