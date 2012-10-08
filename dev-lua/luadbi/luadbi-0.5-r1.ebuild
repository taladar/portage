# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/luadbi/luadbi-0.5-r1.ebuild,v 1.4 2012/09/30 11:57:08 djc Exp $

EAPI=4

inherit multilib toolchain-funcs flag-o-matic eutils

DESCRIPTION="DBI module for Lua"
HOMEPAGE="http://code.google.com/p/luadbi/"
SRC_URI="http://luadbi.googlecode.com/files/${PN}.${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND=">=dev-lang/lua-5.1
		mysql? ( virtual/mysql )
		postgres? ( dev-db/postgresql-base )
		sqlite? ( >=dev-db/sqlite-3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}/${PV}-Makefile.patch"
	epatch "${FILESDIR}/${PV}-postgres-path.patch"
	sed -i -e "s#^INSTALL_DIR_LUA=.*#INSTALL_DIR_LUA=$(pkg-config --variable INSTALL_LMOD lua)#" "${S}/Makefile"
	sed -i -e "s#^INSTALL_DIR_BIN=.*#INSTALL_DIR_BIN=$(pkg-config --variable INSTALL_CMOD lua)#" "${S}/Makefile"
	sed -i -e "s#^LUA_INC_DIR=.*#LUA_INC_DIR=$(pkg-config --variable INSTALL_INC lua)#" "${S}/Makefile"
	sed -i -e "s#^LUA_LIB_DIR=.*#LUA_LIB_DIR=$(pkg-config --variable INSTALL_LIB lua)#" "${S}/Makefile"
	sed -i -e "s#^LUA_LIB =.*#LUA_LIB=lua#" "${S}/Makefile"
}

src_compile() {
	local drivers=""
	use mysql && drivers="${drivers} mysql"
	use postgres && drivers="${drivers} psql"
	use sqlite && drivers="${drivers} sqlite3"

	append-flags -fPIC -c
	for driver in "${drivers}" ; do
		emake ${driver}
	done
}

src_install() {
	local drivers=""
	use mysql && drivers="${drivers} mysql"
	use postgres && drivers="${drivers} psql"
	use sqlite && drivers="${drivers} sqlite3"

	for driver in ${drivers} ; do
		emake DESTDIR="${D}" "install_${driver// /}"
	done
}
