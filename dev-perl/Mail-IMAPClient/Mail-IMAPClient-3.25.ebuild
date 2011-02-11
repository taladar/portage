# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-IMAPClient/Mail-IMAPClient-3.25.ebuild,v 1.3 2011/02/10 23:34:26 hwoarang Exp $

EAPI=2

MODULE_AUTHOR=PLOBBES
inherit perl-module eutils

DESCRIPTION="IMAP client module for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"

RDEPEND=">=dev-perl/Parse-RecDescent-1.94"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod )"
#		>=virtual/perl-File-Temp-0.18 )"
		# only used in t/basic.t

SRC_TEST="do"

mydoc="FAQ"
