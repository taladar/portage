# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/cyrus-imapd/cyrus-imapd-2.4.8.ebuild,v 1.3 2011/05/11 17:58:20 eras Exp $

EAPI=4

inherit db-use eutils ssl-cert pam multilib

MY_P=${P/_/}

DESCRIPTION="The Cyrus IMAP Server."
HOMEPAGE="http://www.cyrusimap.org/"
SRC_URI="ftp://ftp.cyrusimap.org/cyrus-imapd/${MY_P}.tar.gz"
LIBWRAP_PATCH_VER="2.2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="afs kerberos mysql nntp pam postgres replication +sieve snmp sqlite ssl
tcpd zlib"

RDEPEND=">=sys-libs/db-3.2
	>=dev-libs/cyrus-sasl-2.1.13
	afs? ( net-fs/openafs )
	kerberos? ( virtual/krb5 )
	mysql? ( virtual/mysql )
	nntp? ( !net-nntp/leafnode )
	pam? (
			virtual/pam
			>=net-mail/mailbase-1
		)
	postgres? ( dev-db/postgresql-base )
	snmp? ( >=net-analyzer/net-snmp-5.2.2-r1 )
	sqlite? ( dev-db/sqlite )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 snmp? ( net-analyzer/net-snmp[tcpd=] ) )
	zlib? ( sys-libs/zlib )"

DEPEND="$RDEPEND"

# get rid of old style virtual - bug 350792
# all blockers really needed?
RDEPEND="${RDEPEND}
	!net-mail/dovecot
	!mail-mta/courier
	!net-mail/bincimap
	!net-mail/courier-imap
	!net-mail/uw-imap"

REQUIRED_USE="afs? ( kerberos )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewuser cyrus -1 -1 /usr/cyrus mail
}

src_prepare() {
	# Fix master(8)->cyrusmaster(8) manpage.
	for i in `grep -rl -e 'master\.8' -e 'master(8)' "${S}"` ; do
		sed -i -e 's:master\.8:cyrusmaster.8:g' \
			-e 's:master(8):cyrusmaster(8):g' \
			"${i}" || die "sed failed" || die "sed failed"
	done
	mv man/master.8 man/cyrusmaster.8 || die "mv failed"
	sed -i -e "s:MASTER:CYRUSMASTER:g" \
		-e "s:Master:Cyrusmaster:g" \
		-e "s:master:cyrusmaster:g" \
		man/cyrusmaster.8 || die "sed failed"

	# do not strip
	sed -i -e '/(INSTALL/s/-s //' "${S}"/imtest/Makefile.in
}

src_configure() {
	local myconf
	if use mysql ; then
		myconf=$(mysql_config --include)
		myconf="--with-mysql-incdir=${myconf#-I}"
	fi
	econf \
		--enable-murder \
		--enable-netscapehack \
		--enable-idled \
		--with-service-path=/usr/$(get_libdir)/cyrus \
		--with-cyrus-user=cyrus \
		--with-cyrus-group=mail \
		--with-com_err=yes \
		--with-sasl \
		--without-perl \
		--without-krb \
		--without-krbdes \
		--with-bdb \
		--with-bdb-incdir=$(db_includedir) \
		$(use_enable afs) \
		$(use_enable afs krb5afspts) \
		$(use_enable nntp) \
		$(use_enable replication) \
		$(use_enable kerberos gssapi) \
		$(use_enable sieve) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with sqlite) \
		$(use_with ssl openssl) \
		$(use_with snmp) \
		$(use_with tcpd libwrap) \
		$(use_with zlib) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "email install failed"

	doman man/*.[0-8]
	dodoc README*
	dohtml doc/*.html doc/murder.png
	docinto text
	dodoc doc/text/*
	cp doc/cyrusv2.mc "${D}/usr/share/doc/${PF}/html"
	cp -r contrib tools "${D}/usr/share/doc/${PF}"
	rm -f doc/text/Makefile*

	insinto /etc
	doins "${FILESDIR}/cyrus.conf" "${FILESDIR}/imapd.conf"

	newinitd "${FILESDIR}/cyrus.rc6" cyrus
	newconfd "${FILESDIR}/cyrus.confd" cyrus
	newpamd "${FILESDIR}/cyrus.pam-include" sieve

	for subdir in imap/{,db,log,msg,proc,socket,sieve} spool/imap/{,stage.} ; do
		keepdir "/var/${subdir}"
		fowners cyrus:mail "/var/${subdir}"
		fperms 0750 "/var/${subdir}"
	done
	for subdir in imap/{user,quota,sieve} spool/imap ; do
		for i in a b c d e f g h i j k l m n o p q r s t v u w x y z ; do
			keepdir "/var/${subdir}/${i}"
			fowners cyrus:mail "/var/${subdir}/${i}"
			fperms 0750 "/var/${subdir}/${i}"
		done
	done
}

pkg_postinst() {
	# do not install server.{key,pem) if they exist.
	if use ssl ; then
		if [ ! -f "${ROOT}"etc/ssl/cyrus/server.key ]; then
			install_cert /etc/ssl/cyrus/server
			chown cyrus:mail "${ROOT}"etc/ssl/cyrus/server.{key,pem}
		fi
	fi

	elog "For correct logging add the following to /etc/syslog.conf:"
	elog "    local6.*         /var/log/imapd.log"
	elog "    auth.debug       /var/log/auth.log"
	echo

	elog "You have to add user cyrus to the sasldb2. Do this with:"
	elog "    saslpasswd2 cyrus"
}
