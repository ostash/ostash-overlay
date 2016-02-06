# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Per-Face Texture Mapping for Production Rendering"
HOMEPAGE="http://ptex.us/ https://github.com/wdas/ptex"
SRC_URI="https://github.com/wdas/ptex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# TODO: static-libs

RESTRICT=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

src_install() {
	cmake-utils_src_install
# TODO: get rid of *.a if no static-libs requested
}
