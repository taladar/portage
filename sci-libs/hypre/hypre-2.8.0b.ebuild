# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/hypre/hypre-2.8.0b.ebuild,v 1.1 2012/01/22 03:32:23 bicatali Exp $

EAPI=4

inherit fortran-2 eutils

DESCRIPTION="Parallel matrix preconditioners library"
HOMEPAGE="http://acts.nersc.gov/hypre/"
SRC_URI="https://computation.llnl.gov/casc/hypre/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="blas doc examples fortran lapack mpi"

RDEPEND="mpi? ( virtual/mpi )
	blas? ( virtual/blas )
	lapack? ( virtual/lapack )"
DEPEND="${RDEPEND}
	fortran? ( virtual/fortran )
	dev-util/pkgconfig"

DOCS=( "${WORKDIR}"/${P}/{CHANGELOG,COPYRIGHT,README} )

S="${WORKDIR}/${P}/src"

src_prepare() {
	# link with system superlu and propagate LDFLAGS
	sed -i \
		-e 's:@LIBS@:@LIBS@ -lsuperlu:' \
		-e 's:_SHARED@:_SHARED@ $(LDFLAGS):g' \
		config/Makefile.config.in || die
}

src_configure() {
	myeconfargs+=(
		--enable-shared
		--without-superlu
		$(use_enable fortran)
		$(use_with mpi MPI)
	)
	if use blas; then
		myeconfargs+=(
			--with-blas-libs="$(pkg-config --libs-only-l blas | sed -e 's/-l//g')"
			--with-blas-lib-dirs="$(pkg-config --libs-only-L blas | sed -e 's/-L//g')"
		)
	else
		myeconfargs+=( --without-blas )
	fi
	if use lapack; then
		myeconfargs+=(
			--with-lapack-libs="$(pkg-config --libs-only-l lapack | sed -e 's/-l//g')"
			--with-lapack-lib-dirs="$(pkg-config --libs-only-L lapack | sed -e 's/-L//g')"
		)
	else
		myeconfargs+=( --without-lapack )
	fi
	econf "${myeconfargs[@]}"
}

src_install() {
	dolib.so hypre/lib/lib*
	insinto /usr/include/hypre
	doins -r hypre/include

	use doc && dodoc "${WORKDIR}"/${P}/docs/*.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
