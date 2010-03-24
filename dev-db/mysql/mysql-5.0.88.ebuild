# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql/mysql-5.0.88.ebuild,v 1.4 2010/03/24 03:32:52 robbat2 Exp $

MY_EXTRAS_VER="20100131-0301Z"
EAPI=2

inherit toolchain-funcs mysql
# only to make repoman happy. it is really set in the eclass
IUSE="$IUSE"

# Define the mysql-extras source
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/mysql-extras.git"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~alpha ~amd64 ~arm  ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"

# When MY_EXTRAS is bumped, the index should be revised to exclude these.
EPATCH_EXCLUDE=''

DEPEND="|| ( >=sys-devel/gcc-4.3 >=sys-devel/gcc-apple-4.2 )"
RDEPEND=""

# Please do not add a naive src_unpack to this ebuild
# If you want to add a single patch, copy the ebuild to an overlay
# and create your own mysql-extras tarball, looking at 000_index.txt

# Official test instructions:
# USE='berkdb -cluster embedded extraengine perl ssl community' \
# FEATURES='test userpriv -usersandbox' \
# ebuild mysql-X.X.XX.ebuild \
# digest clean package
src_test() {
	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

	emake check || die "make check failed"
	if ! use "minimal" ; then
		if [[ $UID -eq 0 ]]; then
			die "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
		fi
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"
		cd "${S}"
		einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"
		local retstatus1
		local retstatus2
		local t
		addpredict /this-dir-does-not-exist/t9.MYI

		# Ensure that parallel runs don't die
		export MTR_BUILD_THREAD="$((${RANDOM} % 100))"

		# archive_gis really sucks a lot, but it's only relevant for the
		# USE=extraengines case
		case ${PV} in
			5.0.42)
			mysql_disable_test "archive_gis" "Totally broken in 5.0.42"
			;;

			5.0.4[3-9]|5.0.[56]*|5.0.70|5.0.87)
			[ "$(tc-endian)" == "big" ] && \
			mysql_disable_test \
				"archive_gis" \
				"Broken in 5.0.43-70 and 5.0.87 on big-endian boxes only"
			;;
		esac

		# This was a slight testcase breakage when the read_only security issue
		# was fixed.
		case ${PV} in
			5.0.54|5.0.51*)
			mysql_disable_test \
				"read_only" \
				"Broken in 5.0.51-54, output in wrong order"
			;;
		esac

		# Ditto to read_only
		[ "${PV}" == "5.0.51a" ] && \
			mysql_disable_test \
				"view" \
				"Broken in 5.0.51, output in wrong order"

		# x86-specific, OOM issue with some subselects on low memory servers
		[ "${PV}" == "5.0.54" ] && \
			[ "${ARCH/x86}" != "${ARCH}" ] && \
			mysql_disable_test \
				"subselect" \
				"Testcase needs tuning on x86 for oom condition"

		# Broke with the YaSSL security issue that didn't affect Gentoo.
		[ "${PV}" == "5.0.56" ] && \
			for t in openssl_1 rpl_openssl rpl_ssl ssl \
				ssl_8k_key ssl_compress ssl_connect ; do \
				mysql_disable_test \
					"$t" \
					"OpenSSL tests broken on 5.0.56"
			done

		# New test was broken in first time
		# Upstream bug 41066
		# http://bugs.mysql.com/bug.php?id=41066
		[ "${PV}" == "5.0.72" ] && \
			mysql_disable_test \
				"status2" \
				"Broken in 5.0.72, new test is broken, upstream bug #41066"

		# The entire 5.0 series has pre-generated SSL certificates, they have
		# mostly expired now. ${S}/mysql-tests/std-data/*.pem
		# The certs really SHOULD be generated for the tests, so that they are
		# not expiring like this. We cannot do so ourselves as the tests look
		# closely as the cert path data, and we do not have the CA key to regen
		# ourselves. Alternatively, upstream should generate them with at least
		# 50-year validity.
		#
		# Known expiry points:
		# 4.1.*, 5.0.0-5.0.22, 5.1.7: Expires 2013/09/09
		# 5.0.23-5.0.77, 5.1.7-5.1.22?: Expires 2009/01/27
		# 5.0.78-5.0.90, 5.1.??-5.1.42: Expires 2010/01/28
		#
		# mysql-test/std_data/untrusted-cacert.pem is MEANT to be
		# expired/invalid.
		case ${PV} in
			5.0.*|5.1.*)
				for t in openssl_1 rpl_openssl rpl_ssl ssl ssl_8k_key \
					ssl_compress ssl_connect ; do \
					mysql_disable_test \
						"$t" \
						"These OpenSSL tests break due to expired certificates"
				done
			;;
		esac

		# create directories because mysqladmin might right out of order
		mkdir -p "${S}"/mysql-test/var-{ps,ns}{,/log}

		# We run the test protocols seperately
		make -j1 test-ns force="--force --vardir=${S}/mysql-test/var-ns"
		retstatus1=$?
		[[ $retstatus1 -eq 0 ]] || eerror "test-ns failed"
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		#make -j1 test-ps force="--force --vardir=${S}/mysql-test/var-ps"
		#retstatus2=$?
		retstatus2=0
		[[ $retstatus2 -eq 0 ]] || eerror "test-ps failed"
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		# Cleanup is important for these testcases.
		pkill -9 -f "${S}/ndb" 2>/dev/null
		pkill -9 -f "${S}/sql" 2>/dev/null
		failures=""
		[[ $retstatus1 -eq 0 ]] || failures="test-ns"
		[[ $retstatus2 -eq 0 ]] || failures="${failures} test-ps"
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"
		[[ -z "$failures" ]] || die "Test failures: $failures"
		einfo "Tests successfully completed"
	else
		einfo "Skipping server tests due to minimal build."
	fi
}
