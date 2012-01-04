# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-SizeLimit/Apache-SizeLimit-0.960.0.ebuild,v 1.1 2012/01/04 15:09:09 idl0r Exp $

EAPI=4

MODULE_AUTHOR=PHRED
MODULE_VERSION=0.96
inherit perl-module

DESCRIPTION="Graceful exit for large children"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

# mod_perl < 2.0.5 bundles Apache-SizeLimit
DEPEND="${RDEPEND}
	test? ( >=dev-perl/Apache-Test-1.360.0 )"
RDEPEND="dev-perl/Linux-Pid
	!<www-apache/mod_perl-2.0.5
	>=www-apache/mod_perl-2.0.5"

SRC_TEST="do"
