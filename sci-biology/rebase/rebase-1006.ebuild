# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/rebase/rebase-1006.ebuild,v 1.8 2011/03/09 19:01:35 armin76 Exp $

EAPI="3"

MY_PV=${PV#1}

DESCRIPTION="A restriction enzyme database"
LICENSE="public-domain"
HOMEPAGE="http://rebase.neb.com"
SRC_URI="mirror://gentoo/${P}.tar.xz"

SLOT="0"
# Minimal build keeps only the indexed files (if applicable) and the
# documentation. The non-indexed database is not installed.
IUSE="emboss minimal"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

RDEPEND="emboss? ( >=sci-biology/emboss-5.0.0 )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

RESTRICT="binchecks strip"

src_compile() {
	if use emboss; then
		echo; einfo "Indexing Rebase for usage with EMBOSS."
		mkdir REBASE
		EMBOSS_DATA="." rebaseextract -auto -infile withrefm.${MY_PV} \
				-protofile proto.${MY_PV} -equivalences \
				|| die "Indexing Rebase failed."
		echo
	fi
}

src_install() {
	if ! use minimal; then
		insinto /usr/share/${PN}
		doins withrefm.${MY_PV} proto.${MY_PV} || die \
				"Failed to install raw database."
	fi
	newdoc REBASE.DOC README || die "Failed to install documentation."
	if use emboss; then
		insinto /usr/share/EMBOSS/data/REBASE
		doins REBASE/embossre.{enz,ref,sup} || die \
				"Failed to install EMBOSS data files."
		insinto /usr/share/EMBOSS/data
		doins REBASE/embossre.equ \
				|| die "Failed to install enzyme prototypes file."
	fi
}
