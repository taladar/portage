# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-id/myspell-id-20060316.ebuild,v 1.16 2010/05/22 11:19:54 armin76 Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"id,ID,id_ID,Indonesian (Indonesia),id_ID.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"id,ID,hyph_id_ID,Indonesian (Indonesia),hyph_id_ID.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Indonesian dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
