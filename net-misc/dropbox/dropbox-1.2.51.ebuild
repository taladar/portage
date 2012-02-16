# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dropbox/dropbox-1.2.51.ebuild,v 1.2 2012/02/16 13:25:33 jlec Exp $

EAPI="4"

inherit gnome2-utils pax-utils

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)"
HOMEPAGE="http://dropbox.com/"
SRC_URI="x86? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86-${PV}.tar.gz )
	amd64? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86_64-${PV}.tar.gz )"

LICENSE="CCPL-Attribution-NoDerivs-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

QA_DT_HASH="opt/${PN}/.*"
QA_EXECSTACK_x86="opt/dropbox/_ctypes.so"
QA_EXECSTACK_amd64="opt/dropbox/_ctypes.so"

DEPEND=""
# Be sure to have GLIBCXX_3.4.9, #393125
RDEPEND="
	dev-libs/popt
	dev-libs/openssl:0.9.8
	>=sys-devel/gcc-4.2.0
	net-misc/wget
	net-misc/rsync
	media-libs/libpng:1.2"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}"
	mv "${WORKDIR}/.dropbox-dist" "${S}"/src || die
	cd "${S}"/src
	rm -vf libstdc++.so.6 libz* libssl* libbz2* libpopt.so.0 librsync.so.1 libcrypto.so.0.9.8 libpng12.so.0 || die
	pax-mark cm "${S}/src/dropbox"
	cd ${WORKDIR}
}

src_install() {
	cd src || die
	dodoc README ACKNOWLEDGEMENTS
	rm README ACKNOWLEDGEMENTS || die

	local targetdir="/opt/dropbox"
	insinto "${targetdir}"
	doins -r *
	fperms a+x "${targetdir}/dropbox"
	fperms a+x "${targetdir}/dropboxd"
	dosym "${targetdir}/dropboxd" "/opt/bin/dropbox"

	insinto /usr/share
	doins -r icons
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
