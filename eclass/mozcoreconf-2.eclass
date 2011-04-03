# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mozcoreconf-2.eclass,v 1.19 2011/04/02 17:36:17 jer Exp $
#
# mozcoreconf.eclass : core options for mozilla
# inherit mozconfig-2 if you need USE flags

inherit multilib flag-o-matic python

IUSE="${IUSE} custom-optimization"

RDEPEND="x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXmu
	>=sys-libs/zlib-1.1.4"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	=dev-lang/python-2*[threads]"

# mozconfig_annotate: add an annotated line to .mozconfig
#
# Example:
# mozconfig_annotate "building on ultrasparc" --enable-js-ultrasparc
# => ac_add_options --enable-js-ultrasparc # building on ultrasparc
mozconfig_annotate() {
	declare reason=$1 x ; shift
	[[ $# -gt 0 ]] || die "mozconfig_annotate missing flags for ${reason}\!"
	for x in ${*}; do
		echo "ac_add_options ${x} # ${reason}" >>.mozconfig
	done
}

# mozconfig_use_enable: add a line to .mozconfig based on a USE-flag
#
# Example:
# mozconfig_use_enable truetype freetype2
# => ac_add_options --enable-freetype2 # +truetype
mozconfig_use_enable() {
	declare flag=$(use_enable "$@")
	mozconfig_annotate "$(useq $1 && echo +$1 || echo -$1)" "${flag}"
}

# mozconfig_use_with: add a line to .mozconfig based on a USE-flag
#
# Example:
# mozconfig_use_with kerberos gss-api /usr/$(get_libdir)
# => ac_add_options --with-gss-api=/usr/lib # +kerberos
mozconfig_use_with() {
	declare flag=$(use_with "$@")
	mozconfig_annotate "$(useq $1 && echo +$1 || echo -$1)" "${flag}"
}

# mozconfig_use_extension: enable or disable an extension based on a USE-flag
#
# Example:
# mozconfig_use_extension gnome gnomevfs
# => ac_add_options --enable-extensions=gnomevfs
mozconfig_use_extension() {
	declare minus=$(useq $1 || echo -)
	mozconfig_annotate "${minus:-+}$1" --enable-extensions=${minus}${2}
}

moz_pkgsetup() {
	# Ensure we use C locale when building
	export LANG="C"
	export LC_ALL="C"
	export LC_MESSAGES="C"
	export LC_CTYPE="C"

	# Ensure that we have a sane build enviroment
	export MOZILLA_CLIENT=1
	export BUILD_OPT=1
	export NO_STATIC_LIB=1
	export USE_PTHREADS=1
	export ALDFLAGS=${LDFLAGS}

	python_set_active_version 2
}

mozconfig_init() {
	declare enable_optimize pango_version myext x
	declare XUL=$([[ ${PN} == xulrunner ]] && echo true || echo false)
	declare FF=$([[ ${PN} == firefox ]] && echo true || echo false)
	declare IC=$([[ ${PN} == icecat ]] && echo true || echo false)
	declare SM=$([[ ${PN} == seamonkey ]] && echo true || echo false)
	declare TB=$([[ ${PN} == thunderbird ]] && echo true || echo false)
	declare EM=$([[ ${PN} == enigmail ]] && echo true || echo false)


	####################################
	#
	# Setup the initial .mozconfig
	# See http://www.mozilla.org/build/configure-build.html
	#
	####################################

	case ${PN} in
		*xulrunner)
			cp xulrunner/config/mozconfig .mozconfig \
				|| die "cp xulrunner/config/mozconfig failed" ;;
		*firefox)
			cp browser/config/mozconfig .mozconfig \
				|| die "cp browser/config/mozconfig failed" ;;
		*icecat)
			cp browser/config/mozconfig .mozconfig \
				|| die "cp browser/config/mozconfig failed" ;;
		seamonkey)
			# Must create the initial mozconfig to enable application
			: >.mozconfig || die "initial mozconfig creation failed"
			mozconfig_annotate "" --enable-application=suite ;;
		*thunderbird)
			# Must create the initial mozconfig to enable application
			: >.mozconfig || die "initial mozconfig creation failed"
			mozconfig_annotate "" --enable-application=mail ;;
		enigmail)
			cp mail/config/mozconfig .mozconfig \
				|| die "cp mail/config/mozconfig failed" ;;
	esac

	####################################
	#
	# CFLAGS setup and ARCH support
	#
	####################################

	# Set optimization level
	if [[ ${ARCH} == hppa ]]; then
		mozconfig_annotate "more than -O0 causes a segfault on hppa" --enable-optimize=-O0
	elif [[ ${ARCH} == x86 ]]; then
		mozconfig_annotate "less then -O2 causes a segfault on x86" --enable-optimize=-O2
	elif use custom-optimization || [[ ${ARCH} =~ (alpha|ia64) ]]; then
		# Set optimization level based on CFLAGS
		if is-flag -O0; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-O0
		elif [[ ${ARCH} == ppc ]] && has_version '>=sys-libs/glibc-2.8'; then
			mozconfig_annotate "more than -O1 segfaults on ppc with glibc-2.8" --enable-optimize=-O1
		elif is-flag -O1; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-O1
		elif is-flag -Os; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-Os
		else
			mozconfig_annotate "Gentoo's default optimization" --enable-optimize=-O2
		fi
	else
		# Enable Mozilla's default
		mozconfig_annotate "mozilla default" --enable-optimize
	fi

	# Strip optimization so it does not end up in compile string
	filter-flags '-O*'

	# Strip over-aggressive CFLAGS 
	strip-flags

	# Additional ARCH support
	case "${ARCH}" in
	alpha)
		# Historically we have needed to add -fPIC manually for 64-bit.
		# Additionally, alpha should *always* build with -mieee for correct math
		# operation
		append-flags -fPIC -mieee
		;;

	ia64)
		# Historically we have needed to add this manually for 64-bit
		append-flags -fPIC
		;;

	ppc64)
		append-flags -fPIC -mminimal-toc
		;;

	ppc)
		# Fix to avoid gcc-3.3.x micompilation issues.
		if [[ $(gcc-major-version).$(gcc-minor-version) == 3.3 ]]; then
			append-flags -fno-strict-aliasing
		fi
		;;

	x86)
		if [[ $(gcc-major-version) -eq 3 ]]; then
			# gcc-3 prior to 3.2.3 doesn't work well for pentium4
			# see bug 25332
			if [[ $(gcc-minor-version) -lt 2 ||
				( $(gcc-minor-version) -eq 2 && $(gcc-micro-version) -lt 3 ) ]]
			then
				replace-flags -march=pentium4 -march=pentium3
				filter-flags -msse2
			fi
		fi
		;;
	esac

	if [[ $(gcc-major-version) -eq 3 ]]; then
		# Enable us to use flash, etc plugins compiled with gcc-2.95.3
		mozconfig_annotate "building with >=gcc-3" --enable-old-abi-compat-wrappers

		# Needed to build without warnings on gcc-3
		CXXFLAGS="${CXXFLAGS} -Wno-deprecated"
	fi

	# Go a little faster; use less RAM
	append-flags "$MAKEEDIT_FLAGS"

	####################################
	#
	# mozconfig setup
	#
	####################################

	mozconfig_annotate system_libs \
		--with-system-jpeg \
		--with-system-zlib \
		--enable-pango \
		--enable-svg \
		--enable-system-cairo
		# Requires libpng with apng support
		#--with-system-png \

	mozconfig_annotate disable_update_strip \
		--disable-installer \
		--disable-pedantic \
		--disable-updater \
		--disable-strip \
		--disable-strip-libs \
		--disable-install-strip



	if [[ ${PN} != seamonkey ]]; then
		mozconfig_annotate basic_profile \
			--enable-single-profile \
			--disable-profilesharing \
			--disable-profilelocking
	fi

	# Here is a strange one...
	if is-flag '-mcpu=ultrasparc*' || is-flag '-mtune=ultrasparc*'; then
		mozconfig_annotate "building on ultrasparc" --enable-js-ultrasparc
	fi

	# Currently --enable-elf-dynstr-gc only works for x86,
	# thanks to Jason Wever <weeve@gentoo.org> for the fix.
	if use x86 && [[ ${enable_optimize} != -O0 ]]; then
		mozconfig_annotate "${ARCH} optimized build" --enable-elf-dynstr-gc
	fi

	# jemalloc won't build with older glibc
	! has_version ">=sys-libs/glibc-2.4" && mozconfig_annotate "we have old glibc" --disable-jemalloc
}

makemake2() {
	for m in $(find ../ -name Makefile.in); do
		topdir=$(echo "$m" | sed -r 's:[^/]+:..:g')
		sed -e "s:@srcdir@:.:g" -e "s:@top_srcdir@:${topdir}:g" \
			< ${m} > ${m%.in} || die "sed ${m} failed"
	done
}

# mozconfig_final: display a table describing all configuration options paired
# with reasons, then clean up extensions list
mozconfig_final() {
	declare ac opt hash reason
	echo
	echo "=========================================================="
	echo "Building ${PF} with the following configuration"
	grep ^ac_add_options .mozconfig | while read ac opt hash reason; do
		[[ -z ${hash} || ${hash} == \# ]] \
			|| die "error reading mozconfig: ${ac} ${opt} ${hash} ${reason}"
		printf "    %-30s  %s\n" "${opt}" "${reason:-mozilla.org default}"
	done
	echo "=========================================================="
	echo

	# Resolve multiple --enable-extensions down to one
	declare exts=$(sed -n 's/^ac_add_options --enable-extensions=\([^ ]*\).*/\1/p' \
		.mozconfig | xargs)
	sed -i '/^ac_add_options --enable-extensions/d' .mozconfig
	echo "ac_add_options --enable-extensions=${exts// /,}" >> .mozconfig
}
