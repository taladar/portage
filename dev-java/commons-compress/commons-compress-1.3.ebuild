# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-compress/commons-compress-1.3.ebuild,v 1.4 2012/03/24 17:23:46 phajdan.jr Exp $

EAPI="4"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Commons Compress defines an API for working with ar, cpio, tar, zip, gzip and bzip2 files."

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	test? (	dev-java/junit:4
		dev-java/hamcrest-core
		dev-java/ant-junit:0 )"

S="${WORKDIR}/${P}-src"

JAVA_ANT_BSFIX_EXTRA_ARGS="--maven-cleaning"
EANT_BUILD_TARGET="compile package"
EANT_TEST_GENTOO_CLASSPATH="junit-4 hamcrest-core"

java_prepare() {
	cp "${FILESDIR}"/build.xml . || die "Failed to copy build.xml"

	# osgi stuff mvn ant:ant doesn't handle
	mkdir -p target/osgi || die "Failed to create target dir"
	cp "${FILESDIR}"/MANIFEST.MF target/osgi/ || die "Failed to copy manifest"

	if ! use test; then
		find -name "*.jar" -delete || die "Failed to remove test resources"
	fi
}

src_test() {
	EANT_TEST_TARGET="compile-tests test"
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${PN}-1.1.jar
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
