# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/bfgminer/bfgminer-2.3.4.ebuild,v 1.2 2012/04/27 19:59:18 blueness Exp $

EAPI="4"

inherit eutils

DESCRIPTION="Modular Bitcoin CPU/GPU/FPGA miner in C"
HOMEPAGE="https://bitcointalk.org/index.php?topic=78192.0"
SRC_URI="http://luke.dashjr.org/programs/bitcoin/files/${PN}/${PV}/${P}.tbz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="+adl altivec bitforce +cpumining examples hardened icarus ncurses +opencl padlock sse2 sse2_4way sse4 +udev ztex"
REQUIRED_USE="
	|| ( bitforce cpumining icarus opencl ztex )
	adl? ( opencl )
	altivec? ( cpumining ppc ppc64 )
	padlock? ( cpumining || ( amd64 x86 ) )
	sse2? ( cpumining || ( amd64 x86 ) )
	sse4? ( cpumining amd64 )
"

DEPEND="
	net-misc/curl
	ncurses? (
		sys-libs/ncurses
	)
	dev-libs/jansson
	udev? (
		sys-fs/udev
	)
	ztex? (
		dev-libs/libusb:1
	)
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-util/pkgconfig
	sys-apps/sed
	adl? (
		x11-libs/amd-adl-sdk
	)
	opencl? (
		virtual/opencl
	)
	sse2? (
		>=dev-lang/yasm-1.0.1
	)
	sse4? (
		>=dev-lang/yasm-1.0.1
	)
"

src_prepare() {
	sed -i 's/\(^\#define WANT_.*\(SSE\|PADLOCK\|ALTIVEC\)\)/\/\/ \1/' miner.h
	ln -s /usr/include/ADL/* ADL_SDK/
	epatch "${FILESDIR}/Bugfix-Fix-building-without-OpenCL-support.patch"
}

src_configure() {
	local CFLAGS="${CFLAGS}"
	./autogen.sh
	if ! use altivec; then
		sed -i 's/-faltivec//g' configure
	else
		CFLAGS="${CFLAGS} -DWANT_ALTIVEC=1"
	fi
	use padlock && CFLAGS="${CFLAGS} -DWANT_VIA_PADLOCK=1"
	if use sse2; then
		if use amd64; then
			CFLAGS="${CFLAGS} -DWANT_X8664_SSE2=1"
		else
			CFLAGS="${CFLAGS} -DWANT_X8632_SSE2=1"
		fi
	fi
	use sse2_4way && CFLAGS="${CFLAGS} -DWANT_SSE2_4WAY=1"
	use sse4 && CFLAGS="${CFLAGS} -DWANT_X8664_SSE4=1"
	use hardened && CFLAGS="${CFLAGS} -nopie"

	CFLAGS="${CFLAGS}" \
	econf \
		$(use_enable adl) \
		$(use_enable bitforce) \
		$(use_enable cpumining) \
		$(use_enable icarus) \
		$(use_with ncurses curses) \
		$(use_enable opencl) \
		$(use_with udev libudev) \
		$(use_enable ztex)
	if use opencl; then
		# sanitize directories
		sed -i 's~^\(\#define CGMINER_PREFIX \).*$~\1"'"${EPREFIX}/usr/lib/bfgminer/opencl"'"~' config.h
	fi
	if use ztex; then
		sed -i 's~bitstreams/~'"${EPREFIX}"'/usr/lib/bfgminer/ztex/~' libztex.c
	fi
}

src_install() {
	dobin bfgminer
	dodoc AUTHORS NEWS README
	if use opencl; then
		insinto /usr/lib/bfgminer/opencl
		doins *.cl
	fi
	if use ztex; then
		insinto /usr/lib/bfgminer/ztex
		doins bitstreams/*.bit
	fi
	if use examples; then
		docinto examples
		dodoc api-example.php miner.php API.java api-example.c
	fi
}
