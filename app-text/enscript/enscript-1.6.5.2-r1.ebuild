# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/enscript/enscript-1.6.5.2-r1.ebuild,v 1.1 2011/06/02 10:47:43 dilfridge Exp $

EAPI="2"

inherit eutils

DESCRIPTION="powerful text-to-postscript converter"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/enscript/enscript.html"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
SLOT="0"
LICENSE="GPL-3"
IUSE="nls ruby"

DEPEND="
	sys-devel/flex
	sys-devel/bison
	nls? ( sys-devel/gettext )
"
RDEPEND="nls? ( virtual/libintl )"

src_prepare() {
	epatch "${FILESDIR}"/enscript-1.6.3-language.patch
	epatch "${FILESDIR}"/enscript-1.6.4-ebuild.st.patch
	epatch "${FILESDIR}"/enscript-1.6.5.2-php.st.patch
	use ruby && epatch "${FILESDIR}"/enscript-1.6.2-ruby.patch
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc AUTHORS ChangeLog NEWS README* THANKS TODO || die "dodoc failed"

	insinto /usr/share/enscript/hl
	doins "${FILESDIR}"/ebuild.st || die "doins ebuild.st failed"

	if use ruby ; then
		insinto /usr/share/enscript/hl
		doins "${FILESDIR}"/ruby.st || die "doins ruby.st failed"
	fi
}

pkg_postinst() {
	elog "Now, customize /etc/enscript.cfg."
}
