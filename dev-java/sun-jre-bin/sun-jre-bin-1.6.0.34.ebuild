# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jre-bin/sun-jre-bin-1.6.0.34.ebuild,v 1.2 2012/08/31 22:01:32 ago Exp $

EAPI="4"

inherit java-vm-2 eutils prefix versionator

# This URIs need to be updated when bumping!
JRE_URI="http://www.oracle.com/technetwork/java/javase/downloads/jre6-downloads-1637595.html"

MY_PV="$(get_version_component_range 2)u$(get_version_component_range 4)"
S_PV="$(replace_version_separator 3 '_')"

X86_AT="jre-${MY_PV}-linux-i586.bin"
AMD64_AT="jre-${MY_PV}-linux-x64.bin"
IA64_AT="jre-${MY_PV}-linux-ia64.bin"

DESCRIPTION="Oracle's Java SE Runtime Environment"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/"
SRC_URI="
	amd64? ( ${AMD64_AT} )
	x86? ( ${X86_AT} )"
#	ia64? ( ${IA64_AT} )

LICENSE="Oracle-BCLA-JavaSE"
SLOT="1.6"
KEYWORDS="amd64 ~x86"

IUSE="X alsa jce nsplugin pax_kernel"

RESTRICT="fetch strip"

RDEPEND="
	X? (
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libX11
	)
	alsa? ( media-libs/alsa-lib )
	jce? ( dev-java/sun-jce-bin:1.6 )
	!prefix? ( sys-libs/glibc )"
# scanelf won't create a PaX header, so depend on paxctl to avoid fallback
# marking. #427642
DEPEND="
	pax_kernel? ( sys-apps/paxctl )"

S="${WORKDIR}/jre${S_PV}"

pkg_nofetch() {
	if use x86; then
		AT=${X86_AT}
	elif use amd64; then
		AT=${AMD64_AT}
	elif use ia64; then
		AT=${IA64_AT}
	fi

	einfo "Due to Oracle no longer providing the distro-friendly DLJ bundles, the package"
	einfo "has become fetch restricted again. Alternatives are switching to"
	einfo "dev-java/icedtea-bin:6 or the source-based dev-java/icedtea:6"
	einfo ""
	einfo "Please download ${AT} from:"
	einfo "${JRE_URI}"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	sh "${DISTDIR}"/${A} -noregister || die "Failed to unpack"
}

src_compile() {
	# This needs to be done before CDS - #215225
	java-vm_set-pax-markings "${S}"

	# see bug #207282
	einfo "Creating the Class Data Sharing archives"
	if use x86; then
		bin/java -client -Xshare:dump || die
	fi
	# limit heap size for large memory on x86 #405239
	# this is a workaround and shouldn't be needed.
	bin/java -server -Xmx64m -Xshare:dump || die
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest}"

	# We should not need the ancient plugin for Firefox 2 anymore, plus it has
	# writable executable segments
	if use x86; then
		rm -vf lib/i386/libjavaplugin_oji.so \
			lib/i386/libjavaplugin_nscp*.so
		rm -vrf plugin/i386
	fi
	# Without nsplugin flag, also remove the new plugin
	local arch=${ARCH};
	use x86 && arch=i386;
	if ! use nsplugin; then
		rm -vf lib/${arch}/libnpjp2.so \
			lib/${arch}/libjavaplugin_jni.so
	fi

	dodir "${dest}"
	cp -pPR bin lib man "${ddest}" || die

	# Remove empty dirs we might have copied
	find "${D}" -type d -empty -exec rmdir {} + || die

	dodoc COPYRIGHT README

	if use jce; then
		dodir "${dest}"/lib/security/strong-jce
		mv "${ddest}"/lib/security/US_export_policy.jar \
			"${ddest}"/lib/security/strong-jce || die
		mv "${ddest}"/lib/security/local_policy.jar \
			"${ddest}"/lib/security/strong-jce || die
		dosym /opt/sun-jce-bin-1.6.0/jre/lib/security/unlimited-jce/US_export_policy.jar \
			"${dest}"/lib/security/US_export_policy.jar
		dosym /opt/sun-jce-bin-1.6.0/jre/lib/security/unlimited-jce/local_policy.jar \
			"${dest}"/lib/security/local_policy.jar
	fi

	if use nsplugin; then
		install_mozilla_plugin "${dest}"/lib/${arch}/libnpjp2.so
	fi

	# Install desktop file for the Java Control Panel.
	# Using ${PN}-${SLOT} to prevent file collision with jre and or other slots.
	# make_desktop_entry can't be used as ${P} would end up in filename.
	newicon lib/desktop/icons/hicolor/48x48/apps/sun-jcontrol.png \
		sun-jcontrol-${PN}-${SLOT}.png || die
	sed -e "s#Name=.*#Name=Java Control Panel for Oracle JDK ${SLOT} (${PN})#" \
		-e "s#Exec=.*#Exec=${dest}/bin/jcontrol#" \
		-e "s#Icon=.*#Icon=sun-jcontrol-${PN}-${SLOT}.png#" \
		lib/desktop/applications/sun_java.desktop > \
		"${T}"/jcontrol-${PN}-${SLOT}.desktop || die
	domenu "${T}"/jcontrol-${PN}-${SLOT}.desktop

	# http://docs.oracle.com/javase/6/docs/technotes/guides/intl/fontconfig.html
	rm "${ddest}"/lib/fontconfig.* || die
	cp "${FILESDIR}"/fontconfig.Gentoo.properties-r1 "${T}"/fontconfig.properties || die
	eprefixify "${T}"/fontconfig.properties
	insinto "${dest}"/lib/
	doins "${T}"/fontconfig.properties

	set_java_env "${FILESDIR}/${VMHANDLE}.env-r1"
	java-vm_revdep-mask
}

QA_TEXTRELS_x86="
	opt/${P}/lib/i386/client/libjvm.so
	opt/${P}/lib/i386/motif21/libmawt.so
	opt/${P}/lib/i386/server/libjvm.so"
QA_FLAGS_IGNORED="
	/opt/${P}/bin/java
	/opt/${P}/bin/java_vm
	/opt/${P}/bin/javaws
	/opt/${P}/bin/keytool
	/opt/${P}/bin/orbd
	/opt/${P}/bin/pack200
	/opt/${P}/bin/policytool
	/opt/${P}/bin/rmid
	/opt/${P}/bin/rmiregistry
	/opt/${P}/bin/servertool
	/opt/${P}/bin/tnameserv
	/opt/${P}/bin/unpack200
	/opt/${P}/lib/jexec"
for java_system_arch in amd64 i386; do
	QA_FLAGS_IGNORED+="
		/opt/${P}/lib/${java_system_arch}/headless/libmawt.so
		/opt/${P}/lib/${java_system_arch}/jli/libjli.so
		/opt/${P}/lib/${java_system_arch}/libawt.so
		/opt/${P}/lib/${java_system_arch}/libcmm.so
		/opt/${P}/lib/${java_system_arch}/libdcpr.so
		/opt/${P}/lib/${java_system_arch}/libdeploy.so
		/opt/${P}/lib/${java_system_arch}/libdt_socket.so
		/opt/${P}/lib/${java_system_arch}/libfontmanager.so
		/opt/${P}/lib/${java_system_arch}/libhprof.so
		/opt/${P}/lib/${java_system_arch}/libinstrument.so
		/opt/${P}/lib/${java_system_arch}/libioser12.so
		/opt/${P}/lib/${java_system_arch}/libj2gss.so
		/opt/${P}/lib/${java_system_arch}/libj2pcsc.so
		/opt/${P}/lib/${java_system_arch}/libj2pkcs11.so
		/opt/${P}/lib/${java_system_arch}/libjaas_unix.so
		/opt/${P}/lib/${java_system_arch}/libjava_crw_demo.so
		/opt/${P}/lib/${java_system_arch}/libjavaplugin_jni.so
		/opt/${P}/lib/${java_system_arch}/libjava.so
		/opt/${P}/lib/${java_system_arch}/libjawt.so
		/opt/${P}/lib/${java_system_arch}/libJdbcOdbc.so
		/opt/${P}/lib/${java_system_arch}/libjdwp.so
		/opt/${P}/lib/${java_system_arch}/libjpeg.so
		/opt/${P}/lib/${java_system_arch}/libjsig.so
		/opt/${P}/lib/${java_system_arch}/libjsoundalsa.so
		/opt/${P}/lib/${java_system_arch}/libjsound.so
		/opt/${P}/lib/${java_system_arch}/libmanagement.so
		/opt/${P}/lib/${java_system_arch}/libmlib_image.so
		/opt/${P}/lib/${java_system_arch}/libnative_chmod_g.so
		/opt/${P}/lib/${java_system_arch}/libnative_chmod.so
		/opt/${P}/lib/${java_system_arch}/libnet.so
		/opt/${P}/lib/${java_system_arch}/libnio.so
		/opt/${P}/lib/${java_system_arch}/libnpjp2.so
		/opt/${P}/lib/${java_system_arch}/libnpt.so
		/opt/${P}/lib/${java_system_arch}/librmi.so
		/opt/${P}/lib/${java_system_arch}/libsplashscreen.so
		/opt/${P}/lib/${java_system_arch}/libunpack.so
		/opt/${P}/lib/${java_system_arch}/libverify.so
		/opt/${P}/lib/${java_system_arch}/libzip.so
		/opt/${P}/lib/${java_system_arch}/motif21/libmawt.so
		/opt/${P}/lib/${java_system_arch}/native_threads/libhpi.so
		/opt/${P}/lib/${java_system_arch}/server/libjvm.so
		/opt/${P}/lib/${java_system_arch}/xawt/libmawt.so"
done
