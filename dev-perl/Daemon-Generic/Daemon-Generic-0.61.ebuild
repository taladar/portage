# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Daemon-Generic/Daemon-Generic-0.61.ebuild,v 1.2 2009/09/30 16:37:32 armin76 Exp $

MODULE_AUTHOR="MUIR"
MODULE_SECTION="modules"

inherit perl-module

DESCRIPTION="Framework to provide start/stop/reload for a daemon"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~ia64 ~sparc ~x86"

DEPEND="dev-perl/File-Flock
	dev-perl/File-Slurp"
RDEPEND="${DEPEND}"

SRC_TEST="do"
