# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/method_source/method_source-0.6.5.ebuild,v 1.1 2011/09/10 07:38:23 graaff Exp $

EAPI=4
# jruby crashes on parsing the metadata.
USE_RUBY="ruby18 ree18"

RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="Retrieve the source code for a method."
HOMEPAGE="http://github.com/banister/method_source"
IUSE=""
SLOT="0"

LICENSE="MIT"
KEYWORDS="~amd64"

ruby_add_bdepend "test? ( >=dev-ruby/bacon-1.1.0 >=dev-ruby/open4-1.0.1 )"

ruby_add_rdepend ">=dev-ruby/ruby_parser-2.0.5"

each_ruby_test() {
	${RUBY} -S bacon -k test/test.rb || die "Tests failed."
}
