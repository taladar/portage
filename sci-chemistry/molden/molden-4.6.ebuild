# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/molden/molden-4.6.ebuild,v 1.4 2009/09/23 19:55:12 patrick Exp $

inherit eutils toolchain-funcs flag-o-matic fortran

MY_P="${PN}${PV}"
DESCRIPTION="Display molecular density from GAMESS-UK, GAMESS-US, GAUSSIAN and Mopac/Ampac."
HOMEPAGE="http://www.cmbi.kun.nl/~schaft/molden/molden.html"
SRC_URI="ftp://ftp.cmbi.kun.nl/pub/molgraph/${PN}/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~x86"
IUSE="opengl"

RDEPEND="opengl? ( virtual/glut
	virtual/opengl )
	x11-libs/libXmu"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

FORTRAN="g77 gfortran"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if [[ "${FORTRANC}" = "gfortran" ]]; then
		epatch "${FILESDIR}"/${P}-gfortran.patch
	fi
}

src_compile() {
	# Use -mieee on alpha, according to the Makefile
	use alpha && append-flags -mieee

	# Honor CC, CFLAGS, FC, and FFLAGS from environment;
	# unfortunately a bash bug prevents us from doing typeset and
	# assignment on the same line.
	typeset -a args
	args=( CC="$(tc-getCC) ${CFLAGS}" \
		FC="${FORTRANC}" LDR="${FORTRANC}" FFLAGS="${FFLAGS}" )

	einfo "Building Molden..."
	emake -j1 "${args[@]}" || die "molden emake failed"
	if use opengl ; then
		einfo "Building Molden OpenGL helper..."
		emake -j1 "${args[@]}" moldenogl || die "moldenogl emake failed"
	fi
}

src_install() {
	dobin molden || die "failed to install molden executable."
	if use opengl ; then
		dobin moldenogl || die "failed to install moldenogl."
	fi

	dodoc HISTORY README REGISTER || die "failed to install docs."
	cd doc
	uncompress * && dodoc * || die "failed to install docs."
}
