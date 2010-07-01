# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/courier-imap/courier-imap-4.8.0.ebuild,v 1.2 2010/07/01 11:51:11 voyageur Exp $

EAPI=2
inherit autotools eutils multilib libtool

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

DESCRIPTION="An IMAP daemon designed specifically for maildirs."
HOMEPAGE="http://www.courier-mta.org/"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
IUSE="berkdb debug fam gdbm ipv6 selinux gnutls trashquota"

RDEPEND="gnutls? ( net-libs/gnutls )
		!gnutls? ( >=dev-libs/openssl-0.9.6 )
		>=net-libs/courier-authlib-0.61
		>=net-mail/mailbase-0.00-r8
		berkdb? ( sys-libs/db )
		fam? ( virtual/fam )
		gdbm? ( >=sys-libs/gdbm-1.8.0 )
		selinux? ( sec-policy/selinux-courier-imap )"
DEPEND="${RDEPEND}
		dev-lang/perl
		!mail-mta/courier
		userland_GNU? ( sys-process/procps )"
RDEPEND="${RDEPEND}
		!virtual/imapd"

PROVIDE="virtual/imapd"

RC_VER="4.0.6-r1"
INITD_VER="4.0.6-r1"

pkg_setup() {
	if ! use berkdb && ! use gdbm ; then
		echo
		eerror "Either the 'berkdb' or the 'gdbm' USE flag is required."
		eerror "Please add it to '/etc/make.conf' or '/etc/portage/package.use'."
		eerror "Use 'man 5 portage' for more info on '/etc/portage/package.use'."
		echo
		die "Required USE flag missing."
	fi
}

src_prepare() {
	# Bug #48838. Patch to enable/disable FAM support.
	# 20 Aug 2004 langthang@gentoo.org
	# This patch should fix bug #51540. fam USE flag is not needed for shared folder support.
	epatch "${FILESDIR}"/${PN}-4.0.1-disable-fam-configure.in.patch

	# Kill unneeded call to AC_PROG_SYSCONFTOOL (bug #168206).
	epatch "${FILESDIR}"/${PN}-4.0.6-aclocal-fix.patch

	# These patches should fix problems detecting BerkeleyDB.
	# We now can compile with db4 support.
	if use berkdb ; then
		epatch "${FILESDIR}"/${PN}-4.0.6-db4-bdbobj_configure.in.patch
		epatch "${FILESDIR}"/${PN}-4.0.6-db4-configure.in.patch
	fi

	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local myconf=""

	# 19 Aug 2004 langthang@gentoo.org
	# Default to gdbm if both berkdb and gdbm are present.
	if use gdbm ; then
		einfo "Building with GDBM support"
		myconf="${myconf} --with-db=gdbm"
	elif use berkdb ; then
		einfo "Building with BerkeleyDB support"
		myconf="${myconf} --with-db=db"
	fi

	# Disabling unicode is no longer supported
	# By default all available character sets are included
	# Set ENABLE_UNICODE=iso-8859-1,utf-8,iso-8859-10
	# to include only specified translation tables.
	if [[ -z "${ENABLE_UNICODE}" ]] ; then
		einfo "ENABLE_UNICODE is not set, building with all available character sets"
		myconf="${myconf} --enable-unicode"
	else
		einfo "ENABLE_UNICODE is set, building with unicode=${ENABLE_UNICODE}"
		myconf="${myconf} --enable-unicode=${ENABLE_UNICODE}"
	fi

	if use trashquota ; then
		einfo "Building with Trash Quota Support"
		myconf="${myconf} --with-trashquota"
	fi

	use debug && myconf="${myconf} debug=true"

	# Do the actual build now
	econf \
		--disable-root-check \
		--bindir=/usr/sbin \
		--sysconfdir=/etc/${PN} \
		--libexecdir=/usr/$(get_libdir)/${PN} \
		--localstatedir=/var/lib/${PN} \
		--with-authdaemonvar=/var/lib/${PN}/authdaemon \
		--enable-workarounds-for-imap-client-bugs \
		--with-mailuser=mail \
		--with-mailgroup=mail \
		$(use_with fam) \
		$(use_with ipv6) \
		$(use_with gnutls) \
		${myconf} || die "econf failed"

	# Change the pem file location.
	sed -i -e "s:^\(TLS_CERTFILE=\).*:\1/etc/courier-imap/imapd.pem:" \
		imap/imapd-ssl.dist || \
		die "sed failed"

	sed -i -e "s:^\(TLS_CERTFILE=\).*:\1/etc/courier-imap/pop3d.pem:" \
		imap/pop3d-ssl.dist || \
		die "sed failed"
}

src_compile() {
	# spurious failures with parallel compiles
	emake -j1 || die "emake failed"
}

src_install() {
	dodir /var/lib/${PN} /etc/pam.d
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -Rf "${D}/etc/pam.d"

	# Avoid name collisions in /usr/sbin wrt imapd and pop3d
	cd "${D}/usr/sbin"
	for name in imapd pop3d ; do
		mv -f "${name}" "courier-${name}" || die "Failed to mv ${name} to courier-${name}"
	done

	# Hack /usr/lib/courier-imap/foo.rc to use ${MAILDIR} instead of
	# 'Maildir', and to use /usr/sbin/courier-foo names.
	cd "${D}/usr/$(get_libdir)/${PN}"
	for service in {imapd,pop3d}{,-ssl} ; do
		sed -i -e 's/Maildir/${MAILDIR}/' "${service}.rc" || die "sed failed"
		sed -i -e "s/\/usr\/sbin\/${service}/\/usr\/sbin\/courier-${service}/" "${service}.rc" || die "sed failed"
	done

	# Rename the config files correctly and add a value for ${MAILDIR} to them.
	cd "${D}/etc/${PN}"
	for service in {imapd,pop3d}{,-ssl} ; do
		mv -f "${service}.dist" "${service}" || die "Failed to mv ${service}.dist to ${service}"
		echo -e '\n# Hardwire a value for ${MAILDIR}' >> "${service}"
		echo 'MAILDIR=.maildir' >> "${service}"
		echo 'MAILDIRPATH=.maildir' >> "${service}"
	done
	for service in imapd pop3d ; do
		echo -e '# Put any program for ${PRERUN} here' >> "${service}"
		echo 'PRERUN=' >> "${service}"
		echo -e '# Put any program for ${LOGINRUN} here' >> "${service}"
		echo -e '# this is for relay-ctrl-allow in 4*' >> "${service}"
		echo 'LOGINRUN=' >> "${service}"
	done

	cd "${D}/usr/sbin"
	for x in * ; do
		if [[ -L "${x}" ]] ; then
			rm -f "${x}" || die "Failed to rm ${x}"
		fi
	done

	cd ../share
	mv -f * ../sbin
	mv -f ../sbin/man .
	cd ..

	for x in mkimapdcert mkpop3dcert ; do
		mv -f "${D}/usr/sbin/${x}" "${D}/usr/sbin/${x}.orig" || die "Failed to mv /usr/sbin/${x} to /usr/sbin/${x}.orig"
	done

	exeinto /usr/sbin
	doexe "${FILESDIR}/mkimapdcert" "${FILESDIR}/mkpop3dcert" || die "doexe failed"

	dosym /usr/sbin/courierlogger /usr/$(get_libdir)/${PN}/courierlogger || die "dosym failed"

	mkdir "${WORKDIR}/tmp" ; cd "${WORKDIR}/tmp"
	for initd in courier-{imapd,pop3d}{,-ssl} ; do
		sed -e "s:GENTOO_LIBDIR:$(get_libdir):g" "${FILESDIR}/${PN}-${INITD_VER}-${initd}.rc6" > "${initd}" || die "initd libdir-sed failed"
		doinitd "${initd}" || die "doinitd ${initd} failed"
	done
	exeinto /usr/$(get_libdir)/${PN}
	for exe in gentoo-{imapd,pop3d}{,-ssl}.rc courier-{imapd,pop3d}.indirect ; do
		sed -e "s:GENTOO_LIBDIR:$(get_libdir):g" "${FILESDIR}/${PN}-${RC_VER}-${exe}" > "${exe}" || die "exe libdir-sed failed"
		doexe "${exe}" || die "doexe ${exe} failed"
	done

	dodir /usr/bin
	mv -f "${D}/usr/sbin/maildirmake" "${D}/usr/bin/maildirmake" || die "Failed to mv /usr/sbin/maildirmake to /usr/bin/maildirmake"

	# Bug #45953, more docs.
	cd "${S}"
	dohtml -r "${S}"/*
	dodoc "${S}"/{00README.NOW.OR.SUFFER,AUTHORS,INSTALL,NEWS,README,ChangeLog} "${FILESDIR}"/${PN}-gentoo.readme
	docinto imap
	dodoc "${S}"/imap/{ChangeLog,BUGS,BUGS.html,README}
	docinto maildir
	dodoc "${S}"/maildir/{AUTHORS,INSTALL,README.maildirquota.txt,README.sharedfolders.txt}
	docinto tcpd
	dodoc "${S}"/tcpd/README.couriertls
}

pkg_postinst() {
	elog "Authdaemond is no longer provided by this package."
	elog "Authentication libraries are now in courier-authlib."
	elog "For a quick-start howto please refer to"
	elog "${PN}-gentoo.readme in /usr/share/doc/${PF}"
	# Some users have been reporting that permissions on this directory were
	# getting scrambled, so let's ensure that they are sane.
	chmod 0755 "${ROOT}/usr/$(get_libdir)/${PN}" || die "Failed to ensure sane permissions on ${ROOT}/usr/$(get_libdir)/${PN}"
}

src_test() {
	ewarn "make check is not supported by this package due to the"
	ewarn "--enable-workarounds-for-imap-client-bugs option."
}
