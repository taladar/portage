# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-NYTProf/Devel-NYTProf-4.60.ebuild,v 1.1 2011/01/12 21:10:02 tove Exp $

EAPI=3

MODULE_AUTHOR=TIMB
MODULE_VERSION=4.06
inherit perl-module

DESCRIPTION="Powerful feature-rich perl source code profiler"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Getopt-Long
	dev-perl/JSON-Any
"
#	virtual/perl-XSLoader
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.84
	)
"
SRC_TEST="do"
