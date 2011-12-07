# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/perlqt/perlqt-4.7.3.ebuild,v 1.4 2011/12/07 12:00:50 phajdan.jr Exp $

EAPI=4

DECLARATIVE_REQUIRED="optional"
MULTIMEDIA_REQUIRED="optional"
OPENGL_REQUIRED="optional"
QTHELP_REQUIRED="optional"
KDE_REQUIRED="never"
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="Qt Perl bindings"
KEYWORDS="~amd64 x86"
IUSE="debug phonon qimageblitz qscintilla qwt webkit"

RDEPEND="
	>=dev-lang/perl-5.10.1
	dev-perl/List-MoreUtils
	$(add_kdebase_dep smokeqt 'declarative?,multimedia?,opengl?,phonon?,qimageblitz?,qscintilla?,qthelp?,qwt?,webkit?')
"
DEPEND=${RDEPEND}

# Split from kdebindings-perl in 4.7
add_blocker kdebindings-perl

RESTRICT="test"
# bug 392991

PATCHES=( "${FILESDIR}/${PN}-4.7.2-vendor.patch" )

src_configure() {
	local mycmakeargs=(
		-DDISABLE_Qt3Support=ON
		$(cmake-utils_use_disable declarative QtDeclarative)
		$(cmake-utils_use_disable multimedia QtMultimedia)
		$(cmake-utils_use_disable opengl QtOpenGL)
		$(cmake-utils_use_with phonon)
		$(cmake-utils_use_with qimageblitz QImageBlitz)
		$(cmake-utils_use_with qscintilla QScintilla)
		$(cmake-utils_use_disable qthelp QtHelp)
		$(cmake-utils_use_disable qwt)
		$(cmake-utils_use_disable webkit QtWebKit)
	)
	kde4-base_src_configure
}
