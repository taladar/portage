# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/gx-mail-notify/gx-mail-notify-0.4.2.ebuild,v 1.2 2010/10/06 20:45:45 tampakrap Exp $

EAPI=2
inherit kde4-base

MY_P=gx_mail_notify-${PV}

DESCRIPTION="A plasmoid for checking unread mail"
HOMEPAGE="http://www.kde-look.org/content/show.php/GX+Mail+Notify?content=99617"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/99617-${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=kde-base/kdelibs-${KDE_MINIMAL}[opengl]
	>=kde-base/plasma-workspace-${KDE_MINIMAL}"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

DOCS="README"
