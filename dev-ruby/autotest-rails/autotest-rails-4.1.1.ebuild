# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/autotest-rails/autotest-rails-4.1.1.ebuild,v 1.1 2011/09/10 08:08:48 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="This is an autotest plugin to provide rails support."
HOMEPAGE="http://rubyforge.org/projects/zentest/"
LICENSE="MIT"

KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-macos"
SLOT="0"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/hoe )"
ruby_add_rdepend ">=dev-ruby/zentest-4.5"
