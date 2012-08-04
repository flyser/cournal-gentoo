# Copyright 1999-2012 Fabian Henze
# Distributed under the terms of the GNU General Public License v2

EAPI=4

PYTHON_DEPEND="3:3.1"

inherit distutils eutils gnome2-utils fdo-mime

DESCRIPTION="A collaborative note taking and journal application using a stylus."
HOMEPAGE="http://cournal-project.org/"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://github/flyser/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
elif [[ ${PR} == "r0" ]]; then
	inherit git-2 mercurial
	EGIT_REPO_URI="git://github.com/flyser/cournal"
	# Twisted for python3:
	EHG_REPO_URI="https://bitbucket.org/pitrou/t3k"
	EHG_PROJECT="t3k"
	KEYWORDS=""
else
	REPO_URI="/home/flyser/projekte/cournal"
	# Twisted for python3:
	EHG_REPO_URI="https://bitbucket.org/pitrou/t3k"
	EHG_PROJECT="t3k"
	KEYWORDS=""
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	>=app-text/poppler-0.18[cairo,introspection]
	dev-libs/gobject-introspection
	>=net-zope/zope-interface-3.6.0
	>=x11-libs/gtk+-3.2
	x11-themes/hicolor-icon-theme
	dev-util/desktop-file-utils"
DEPEND="
	sys-devel/gettext
	dev-util/intltool"

pkg_setup() {
	python_set_active_version 3
	python_pkg_setup
}

src_unpack() {
	if [[ ${PV} != *9999* ]]; then
		unpack ${A}
	elif [[ ${PR} == "r0" ]]; then
		git-2_src_unpack
		S="$S/../t3k" mercurial_src_unpack
		cd "$S"
		ln -s "$S"/../t3k/twisted "$S"/cournal/twisted
	else
		cp -r "$REPO_URI" "$S"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

src_install () {
	dodoc THANKS
	distutils_src_install
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}
