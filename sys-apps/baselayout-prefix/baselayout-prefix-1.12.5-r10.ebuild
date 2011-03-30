# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/baselayout-prefix/baselayout-prefix-1.12.5-r10.ebuild,v 1.1 2011/03/30 11:34:45 haubi Exp $

EAPI=3

inherit eutils toolchain-funcs multilib prefix flag-o-matic autotools

# Needed gnulib modules:
#   getopt: for AIX
#   strsep: for Solaris
# Avoid depending on dev-libs/gnulib, might be missing during bootstrap.
# The gnulib tarball has been created using these commands (basically):
# $ gnulib-tool --create-testdir --dir=gnulib getopt strsep
# $ eautoreconf
# $ econf
# $ make maintainer-clean
GNULIBV=1

DESCRIPTION="Minimal baselayout for Gentoo Prefix installs"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="
	http://dev.gentoo.org/~grobian/distfiles/${P/-prefix/}.tar.bz2
	http://dev.gentoo.org/~haubi/distfiles/${P/-prefix/}-gnulib-${GNULIBV}.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc-aix ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="prefix-chaining"
DEPEND=">=sys-apps/portage-2.2.01"
RDEPEND=">=sys-libs/readline-5.0-r1
	>=app-shells/bash-3.1_p7
	>=sys-apps/coreutils-5.2.1
	kernel_Darwin? ( sys-process/pidof-bsd )
	kernel_FreeBSD? ( sys-process/pidof-bsd )"

S=${WORKDIR}/${P/-prefix}

src_prepare() {
	epatch "${FILESDIR}"/${P/-prefix/}-prefix.patch

	if use prefix-chaining; then
		epatch "${FILESDIR}"/${P/-prefix/}-prefix-chaining.patch
		epatch "${FILESDIR}"/${P/-prefix/}-prefix-chaining-pkgconfig.patch
		epatch "${FILESDIR}"/${P/-prefix/}-prefix-chaining-recursion.patch
		epatch "${FILESDIR}"/${P/-prefix/}-prefix-chaining-eprefix.patch
		epatch "${FILESDIR}"/${P/-prefix/}-prefix-chaining-prompt.patch
		epatch "${FILESDIR}"/${P/-prefix/}-prefix-chaining-bash.patch

		# need to set the PKG_CONFIG_PATH globally for this prefix, when
		# chaining is enabled, since pkg-config may not be installed locally,
		# but still .pc files should be found for all RDEPENDable prefixes in
		# the chain.
		echo "PKG_CONFIG_PATH=\"${EPREFIX}/usr/lib/pkgconfig:${EPREFIX}/usr/share/pkgconfig\"" >> "${S}"/etc/env.d/00basic
	fi

	epatch "${FILESDIR}"/${P/-prefix/}-prefix-src.patch
	epatch "${FILESDIR}"/${P/-prefix/}-prefix-sh.patch
	# Next patch is to be applied on systems that don't have a pidof.
	epatch "${FILESDIR}"/${P/-prefix/}-prefix-pidof.patch

	epatch "${FILESDIR}"/${P/-prefix/}-termios_h.patch # required by aix.patch
	epatch "${FILESDIR}"/${P/-prefix/}-aix.patch
	epatch "${FILESDIR}"/${P/-prefix/}-darwin-kvm.patch
	epatch "${FILESDIR}"/${P/-prefix/}-solaris.patch
	epatch "${FILESDIR}"/${P/-prefix/}-libsvar.patch

	# The consoletype application in this form will only work on Linux
	[[ ${CHOST} == *-linux-* ]] || epatch "${FILESDIR}"/${P/-prefix/}-prefix-no-consoletype.patch

	cd "${S}"
	eprefixify \
		etc/env.d/00basic \
		etc/profile \
		sbin/env-update.sh \
		sbin/functions.sh \
		sbin/runscript.sh \
		src/runscript.c \
		sbin/depscan.sh \
		sbin/rc-daemon.sh \
		sbin/rc-services.sh
	# add the host OS MANPATH
	echo 'MANPATH="/usr/share/man"' > etc/env.d/99basic || die "can't make file"

	# need to include gnulib's <config.h> first
	sed -i -e '1i#include <config.h>' $(find . -name '*.c') || die "Cannot utilize gnulib"

	# prepare gnulib
	cd "${WORKDIR}"/gnulib || die
	eautoreconf
}

src_configure() {
	cd "${WORKDIR}"/gnulib || die
	default
}

src_compile() {
	# build gnulib first
	cd "${WORKDIR}"/gnulib || die
	emake || die "Cannot build gnulib"
	cd "${S}"

	# use gnulib
	append-flags -I"${WORKDIR}"/gnulib -I"${WORKDIR}"/gnulib/gllib
	append-ldflags -L"${WORKDIR}"/gnulib/gllib
	append-libs gnu

	local libdir="lib"

	[[ ${SYMLINK_LIB} == "yes" ]] && libdir=$(get_abi_LIBDIR "${DEFAULT_ABI}")

	make -C "${S}"/src \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) ${LDFLAGS}" \
		CFLAGS="${CFLAGS}" \
		LIBDIR="${libdir}" || die
}

src_install() {
	local dir libdirs libdirs_env rcscripts_dir

	dodir /etc
	dodir /etc/env.d
	dodir /etc/init.d			# .keep file might mess up init.d stuff

	libdirs=$(get_all_libdirs)
	: ${libdirs:=lib}	# it isn't that we don't trust multilib.eclass...

	rcscripts_dir="/lib/rcscripts"

	for dir in ${libdirs}; do
		libdirs_env=${libdirs_env:+$libdirs_env:}/${dir}:/usr/${dir}:/usr/local/${dir}
		[[ ${dir} == "lib" && ${SYMLINK_LIB} == "yes" ]] && continue
		dodir /"${dir}"
		dodir /usr/"${dir}"
		dodir /usr/local/"${dir}"
	done

	# Ugly compatibility with stupid ebuilds and old profiles symlinks
	if [[ ${SYMLINK_LIB} == "yes" ]] ; then
		rm -r "${ED}"/{lib,usr/lib,usr/local/lib} &> /dev/null
		dosym $(get_abi_LIBDIR ${DEFAULT_ABI}) /lib
		dosym $(get_abi_LIBDIR ${DEFAULT_ABI}) /usr/lib
		dosym $(get_abi_LIBDIR ${DEFAULT_ABI}) /usr/local/lib
	fi

	# FHS compatibility symlinks stuff
	dosym /var/tmp /usr/tmp

	# rc-scripts version for testing of features that *should* be present
	echo "Gentoo Prefix Base System version ${PV}" > ${ED}/etc/gentoo-release

	# get the basic stuff in there
	doenvd "${S}"/etc/env.d/* || die "doenvd"

	# copy the profile
	cp "${S}"/etc/profile "${ED}"/etc/profile

	# Setup files in /sbin
	#
	cd "${S}"/sbin
	into /
	# These moved from /etc/init.d/ to /sbin to help newb systems
	# from breaking
	dosbin runscript.sh functions.sh

	# Compat symlinks between /etc/init.d and /sbin
	# (some stuff have hardcoded paths)
	dosym ../../sbin/depscan.sh /etc/init.d/depscan.sh
	dosym ../../sbin/runscript.sh /etc/init.d/runscript.sh
	dosym ../../sbin/functions.sh /etc/init.d/functions.sh

	cd "${S}"/sbin
	into /
	dosbin depscan.sh
	dosbin env-update.sh
	insinto ${rcscripts_dir}/awk
	doins "${S}"/src/awk/functions.awk

	#
	# Install baselayout utilities
	#
	local libdir="lib"
	[[ ${SYMLINK_LIB} == "yes" ]] && libdir=$(get_abi_LIBDIR "${DEFAULT_ABI}")

	cd "${S}"/src
	make DESTDIR="${ED}" LIBDIR="${libdir}" install || die

	insinto ${rcscripts_dir}/sh
	doins "${S}"/sbin/rc-*
}

pkg_postinst() {
	if [[ ${EUID} == 0 ]] ; then
		# setup portage user, such that things that require root privs
		# don't fail, bug #321623
		enewgroup portage 250
		enewuser portage 250 -1 "${EPREFIX}"/var/tmp/portage portage
	fi

	# This is also written in src_install (so it's in CONTENTS), but
	# write it here so that the new version is immediately in the file
	# (without waiting for the user to do etc-update)
	rm -f "${EROOT}"/etc/._cfg????_gentoo-release
	echo "Gentoo Prefix Base System version ${PV}" > "${EROOT}"/etc/gentoo-release

	echo
	einfo "Please be sure to update all pending '._cfg*' files in /etc,"
	einfo "else things might break!  You can use 'etc-update'"
	einfo "to accomplish this:"
	einfo
	einfo "  # etc-update"
	echo
}
