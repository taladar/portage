# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kfloppy/kfloppy-4.6.3.ebuild,v 1.3 2011/06/10 11:51:00 hwoarang Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdeutils"
inherit kde4-meta

DESCRIPTION="KFloppy - formats disks and puts a DOS or ext2fs filesystem on them."
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"
