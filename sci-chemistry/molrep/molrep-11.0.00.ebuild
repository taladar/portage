# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/molrep/molrep-11.0.00.ebuild,v 1.1 2010/06/15 10:51:43 jlec Exp $

EAPI="3"

inherit eutils multilib toolchain-funcs

DESCRIPTION="molecular replacement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~alexei/molrep.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=sci-libs/ccp4-libs-6.1.3
	sci-libs/mmdb
	virtual/lapack"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-respect-FLAGS.patch
	epatch "${FILESDIR}"/${PV}-test.patch
}

src_compile() {
	cd "${S}"/src
	emake clean || die
	emake \
		MR_FORT="$(tc-getFC) ${FFLAGS}" \
		FFLAGS="${FFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		MR_LIBRARY="-L${EPREFIX}/usr/$(get_libdir) -lccp4f -lccp4c -lmmdb -lccif -llapack -lstdc++ -lm" \
		|| die
}

src_test() {
	export MR_TEST="${S}/bin/"
	cd "${S}"/molrep_check/work
	mkdir out scr
	cp ../*.bat .
	bash em.bat || die
	bash mr.bat || die
}

src_install() {
	dobin bin/${PN} || die
	dodoc readme doc/${PN}.rtf || die
}
