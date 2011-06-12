# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/ruby-modes/ruby-modes-1.04.ebuild,v 1.3 2011/06/12 04:32:50 tomka Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Ruby support."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/debug
"
KEYWORDS="~alpha ~amd64 hppa ~ppc ~ppc64 ~sparc x86"

inherit xemacs-packages
