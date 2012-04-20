# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_macro/mod_macro-1.2.1.ebuild,v 1.1 2012/04/20 08:53:40 patrick Exp $

inherit apache-module

DESCRIPTION="An Apache2 module providing macros for the Apache config file."
HOMEPAGE="http://www.coelho.net/mod_macro/"
#SRC_URI="http://www.coelho.net/${PN}/${P}.tar.bz2"
SRC_URI="http://people.apache.org/~fabien/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-devel/libtool"
RDEPEND=""

APACHE2_MOD_CONF="27_${PN}"
APACHE2_MOD_DEFINE="MACRO"

DOCFILES="CHANGES INSTALL README mod_macro.html"

need_apache2_4

src_install() {
	apache-module_src_install
	keepdir "${APACHE_CONFDIR}"/macros.d/
	insinto "${APACHE_CONFDIR}"/macros.d/
	doins "${FILESDIR}"/00_example.conf
}
