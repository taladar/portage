# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-gpg/selinux-gpg-2.20110726-r1.ebuild,v 1.2 2011/09/09 18:38:24 swift Exp $
EAPI="4"

IUSE=""
MODS="gpg"
BASEPOL="2.20110726-r1"
POLICY_PATCH="${FILESDIR}/0021-gpg-fix-mutt-call-r4.patch"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for GnuPG"
KEYWORDS="~amd64 ~x86"
