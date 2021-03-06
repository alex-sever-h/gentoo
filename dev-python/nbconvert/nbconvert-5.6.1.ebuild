# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Converting Jupyter Notebooks"
HOMEPAGE="https://nbconvert.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="
	dev-python/bleach[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	>=dev-python/entrypoints-0.2.2[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	>=dev-python/mistune-0.7.4[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/pandocfilters-1.4.1[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]
	dev-python/testpath[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pebble[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
		>=dev-python/jupyter_client-4.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/{ipython,jupyter_client,nbsphinx,sphinx_rtd_theme}
distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing bdist_egg
	cd "${TEST_DIR}"/lib || die
	pytest -vv --pyargs nbconvert || die
}

pkg_postinst() {
	if ! has_version app-text/pandoc ; then
		einfo "Pandoc is required for converting to formats other than Python,"
		einfo "HTML, and Markdown. If you need this functionality, install"
		einfo "app-text/pandoc."
	fi
}
