# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PDL/PDL-2.4.11.ebuild,v 1.3 2012/08/28 16:37:26 bicatali Exp $

EAPI=4

MODULE_AUTHOR=CHM
inherit perl-module eutils fortran-2

HOMEPAGE="http://pdl.perl.org/"
DESCRIPTION="Perl Data Language for scientific computing"

LICENSE="Artistic as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+badval doc fftw fortran gd gsl hdf netpbm opengl pdl2 proj pgplot plplot threads"

RDEPEND="sys-libs/ncurses
	app-arch/sharutils
	dev-perl/Astro-FITS-Header
	dev-perl/File-Map
	dev-perl/Inline
	dev-perl/TermReadKey
	|| ( dev-perl/Term-ReadLine-Perl dev-perl/Term-ReadLine-Gnu )
	virtual/perl-Data-Dumper
	virtual/perl-PodParser
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Filter
	virtual/perl-Storable
	virtual/perl-Text-Balanced
	fftw? ( sci-libs/fftw:2.1 )
	gd? ( media-libs/gd )
	gsl? ( sci-libs/gsl )
	hdf? ( sci-libs/hdf )
	netpbm? ( media-libs/netpbm virtual/ffmpeg )
	pdl2? ( dev-perl/Devel-REPL )
	proj? ( <sci-libs/proj-4.8 )
	opengl? ( dev-perl/OpenGL )
	pgplot? ( dev-perl/PGPLOT )
	plplot? ( sci-libs/plplot )"

DEPEND="${RDEPEND}
	fortran? ( virtual/fortran >=dev-perl/ExtUtils-F77-1.13 )"

REQUIRED_USE="plplot? ( badval )"

mydoc="BUGS DEPENDENCIES DEVELOPMENT Known_problems MANIFEST* Release_Notes"

SRC_TEST="do"

pkg_setup() {
	perl-module_pkg_setup
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.4.2-makemakerfix.patch
	# respect user choice for fortran compiler+flags, add pic
	epatch "${FILESDIR}"/${PN}-2.4.11-fortran.patch
	# search for shared fftw instead of static
	epatch "${FILESDIR}"/${PN}-2.4.11-shared-fftw.patch
	# search for shared hdf instead of static
	epatch "${FILESDIR}"/${PN}-2.4.11-shared-hdf.patch
	find . -name Makefile.PL -exec \
		sed -i -e "s|/usr|${EPREFIX}/usr|g" {} \; || die
}

src_configure() {
	sed -i \
		-e '/USE_POGL/s/=>.*/=> 1,/' \
		-e "/HTML_DOCS/s/=>.*/=> $(use doc && echo 1 || echo 0),/" \
		-e "/WITH_BADVAL/s/=>.*/=> $(use badval && echo 1|| echo 0),/" \
		-e "/WITH_DEVEL_REPL/s/=>.*/=> $(use pdl2 && echo 1 || echo 0),/" \
		-e "/WITH_FFTW/s/=>.*/=> $(use fftw && echo 1 || echo 0),/" \
		-e "/WITH_GSL/s/=>.*/=> $(use gsl && echo 1 || echo 0),/" \
		-e "/WITH_GD/s/=>.*/=> $(use gd && echo 1 || echo 0),/" \
		-e "/WITH_HDF/s/=>.*/=> $(use hdf && echo 1 || echo 0),/" \
		-e "/WITH_3D/s/=>.*/=> $(use opengl && echo 1 || echo 0),/" \
		-e "/WITH_MINUIT/s/=>.*/=> $(use fortran && echo 1|| echo 0),/" \
		-e "/WITH_PGPLOT/s/=>.*/=> $(use pgplot && echo 1 || echo 0),/" \
		-e "/WITH_PLPLOT/s/=>.*/=> $(use plplot && echo 1 || echo 0),/" \
		-e "/WITH_POSIX_THREADS/s/=>.*/=> $(use threads && echo 1 || echo 0),/" \
		-e "/WITH_PROJ/s/=>.*/=> $(use proj && echo 1 || echo 0),/" \
		-e "/WITH_SLATEC/s/=>.*/=> $(use fortran && echo 1|| echo 0),/" \
		perldl.conf || die
	perl-module_src_configure
}

src_test() {
	MAKEOPTS+=" -j1" perl-module_src_test
}

src_install() {
	perl-module_src_install
	cp Doc/{scantree.pl,mkhtmldoc.pl} \
		"${D}"/${VENDOR_ARCH}/PDL/Doc/ || die
}

pkg_postinst() {
	perl ${VENDOR_ARCH}/PDL/Doc/scantree.pl || die
	elog "Building perldl.db done. You can recreate this at any time"
	elog "by running:"
	elog "perl ${VENDOR_ARCH}/PDL/Doc/scantree.pl"
}

pkg_prerm() {
	rm -rf "${EROOT}"/var/lib/pdl/html
	rm -f  "${EROOT}"/var/lib/pdl/{pdldoc.db,Index.pod}
}
