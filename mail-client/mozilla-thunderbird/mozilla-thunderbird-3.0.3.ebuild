# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mozilla-thunderbird/mozilla-thunderbird-3.0.3.ebuild,v 1.6 2010/03/14 19:22:58 armin76 Exp $
EAPI="2"
WANT_AUTOCONF="2.1"

inherit flag-o-matic toolchain-funcs eutils mozconfig-3 makeedit multilib mozextension autotools

LANGS="af ar be ca cs de el en-US en-GB es-AR es-ES et eu fi fr fy-NL ga-IE hu id is it ja ko lt nb-NO nl nn-NO pa-IN pl pt-BR ro ru si sk sv-SE ta-LK tr uk"
# Languages not rebuilt for beta3 "pt-PT he sr bg gl zn-CN vi"
NOSHORTLANGS="es-AR en-GB pt-BR"

MY_PV2="${PV/_rc/rc}"
MY_P="${P/_rc/rc}"

DESCRIPTION="Thunderbird Mail Client"
HOMEPAGE="http://www.mozilla.com/en-US/thunderbird/"

KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
SLOT="0"
LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
IUSE="ldap crypt bindist lightning mozdom system-sqlite"
PATCH="${PN}-3.0-patches-0.3"

REL_URI="http://releases.mozilla.org/pub/mozilla.org/thunderbird/releases"
SRC_URI="${REL_URI}/${MY_PV2}/source/thunderbird-${MY_PV2}.source.tar.bz2
	http://dev.gentoo.org/~anarchy/dist/${PATCH}.tar.bz2"

for X in ${LANGS} ; do
	if [ "${X}" != "en" ] && [ "${X}" != "en-US" ]; then
		SRC_URI="${SRC_URI}
			linguas_${X/-/_}? ( ${REL_URI}/${MY_PV2}/linux-i686/xpi/${X}.xpi -> ${P}-${X}.xpi )"
	fi
	IUSE="${IUSE} linguas_${X/-/_}"
	# english is handled internally
	if [ "${#X}" == 5 ] && ! has ${X} ${NOSHORTLANGS}; then
		if [ "${X}" != "en-US" ]; then
			SRC_URI="${SRC_URI}
				linguas_${X%%-*}? ( ${REL_URI}/${PV}/linux-i686/xpi/${X}.xpi -> ${P}-${X}.xpi )"
		fi
		IUSE="${IUSE} linguas_${X%%-*}"
	fi
done

RDEPEND=">=sys-devel/binutils-2.16.1
	>=dev-libs/nss-3.12.3
	>=dev-libs/nspr-4.8
	system-sqlite? ( >=dev-db/sqlite-3.6.22-r2[fts3,secure-delete] )
	>=media-libs/lcms-1.17
	>=app-text/hunspell-1.2
	x11-libs/cairo[X]
	x11-libs/pango[X]
	!x11-plugins/lightning"

PDEPEND="crypt? ( >=x11-plugins/enigmail-1.0 )"

S="${WORKDIR}"/comm-1.9.1

linguas() {
	local LANG SLANG
	for LANG in ${LINGUAS}; do
		if has ${LANG} en en_US; then
			has en ${linguas} || linguas="${linguas:+"${linguas} "}en"
			continue
		elif has ${LANG} ${LANGS//-/_}; then
			has ${LANG//_/-} ${linguas} || linguas="${linguas:+"${linguas} "}${LANG//_/-}"
			continue
		elif [[ " ${LANGS} " == *" ${LANG}-"* ]]; then
			for X in ${LANGS}; do
				if [[ "${X}" == "${LANG}-"* ]] && \
					[[ " ${NOSHORTLANGS} " != *" ${X} "* ]]; then
					has ${X} ${linguas} || linguas="${linguas:+"${linguas} "}${X}"
					continue 2
				fi
			done
		fi
		ewarn "Sorry, but ${PN} does not support the ${LANG} LINGUA"
	done
}

pkg_setup() {
	export BUILD_OFFICIAL=1
	export MOZILLA_OFFICIAL=1

	if ! use bindist; then
		elog "You are enabling official branding. You may not redistribute this build"
		elog "to any users on your network or the internet. Doing so puts yourself into"
		elog "a legal problem with Mozilla Foundation"
		elog "You can disable it by emerging ${PN} _with_ the bindist USE-flag"
	fi
}

src_unpack() {
	unpack ${A}

	linguas
	for X in ${linguas}; do
		# FIXME: Add support for unpacking xpis to portage
		[[ ${X} != "en" ]] && xpi_unpack "${P}-${X}.xpi"
	done
	if [[ ${linguas} != "" && ${linguas} != "en" ]]; then
		einfo "Selected language packs (first will be default): ${linguas}"
	fi
}

src_prepare() {
	# Apply our patches
	EPATCH_EXCLUDE="106-bz466250_att349521_fix_ftbfs_with_cairo_fb.patch"
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}"

	eautoreconf

	cd mozilla
	eautoreconf
	cd js/src
	eautoreconf
}

src_configure() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	MEXTENSIONS="default"

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	touch mail/config/mozconfig
	mozconfig_init
	mozconfig_config

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"
	mozconfig_annotate '' --enable-application=mail
	mozconfig_use_enable ldap
	mozconfig_use_enable ldap ldap-experimental
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}
	mozconfig_annotate '' --with-user-appdir=.thunderbird
	mozconfig_annotate '' --with-system-nspr
	mozconfig_annotate '' --with-system-nss
	mozconfig_annotate 'broken' --disable-crashreporter

	# Use enable features
	mozconfig_use_enable lightning calendar
	mozconfig_use_enable system-sqlite

	# Bug #72667
	if use mozdom; then
		MEXTENSIONS="${MEXTENSIONS},inspector"
	fi

	if ! use bindist; then
		mozconfig_annotate '' --enable-official-branding
	fi

	# Finalize and report settings
	mozconfig_final

	####################################
	#
	#  Configure and build
	#
	####################################

	# Disable no-print-directory
	MAKEOPTS=${MAKEOPTS/--no-print-directory/}

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	CPPFLAGS="${CPPFLAGS}" \
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	econf || die
}

src_compile() {
	# Should the build use multiprocessing? Not enabled by default, as it tends to break
	[ "${WANT_MP}" = "true" ] && jobs=${MAKEOPTS} || jobs="-j1"
	emake ${jobs} || die
}

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	emake DESTDIR="${D}" install || die "emake install failed"

	if use lightning ; then
		declare emid

		cd "${T}"
		unzip "${S}"/mozilla/dist/xpi-stage/gdata-provider.xpi install.rdf
		emid=$(sed -n '/<em:id>/!d; s/.*\({.*}\).*/\1/; p; q' install.rdf)

		dodir ${MOZILLA_FIVE_HOME}/extensions/${emid}
		cd "${D}"${MOZILLA_FIVE_HOME}/extensions/${emid}
		unzip "${S}"/mozilla/dist/xpi-stage/gdata-provider.xpi
	fi

	linguas
	for X in ${linguas}; do
		[[ ${X} != "en" ]] && xpi_install "${WORKDIR}"/"${P}-${X}"
	done

	if ! use bindist; then
		newicon "${S}"/other-licenses/branding/thunderbird/content/icon48.png thunderbird-icon.png
		domenu "${FILESDIR}"/icon/${PN}.desktop
	else
		newicon "${S}"/mail/branding/nightly/content/icon48.png thunderbird-icon-unbranded.png
		newmenu "${FILESDIR}"/icon/${PN}-unbranded.desktop \
			${PN}.desktop
	fi

	# Warn user that remerging enigmail is neccessary on USE=crypt
	use crypt && ewarn "Please remerge x11-plugins/enigmail after updating ${PN}."

	# Enable very specific settings for thunderbird-3
	cp "${FILESDIR}"/thunderbird-gentoo-default-prefs.js \
		"${D}/${MOZILLA_FIVE_HOME}/defaults/pref/all-gentoo.js" || \
		die "failed to cp thunderbird-gentoo-default-prefs.js"
}
