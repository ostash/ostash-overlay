# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils vcs-snapshot

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/OpenImageIO"
SRC_URI="https://github.com/OpenImageIO/oiio/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fast-sha1 ffmpeg gif jpeg2k opencolorio opencv qt4 raw +threads tools +truetype"

# TODO: ptex is not in portage
# TODO: field3d - not in portage, searches for hdf5 as well for some reason.
# TODO: python bindings (requires boost[python])

RESTRICT="test" #431412

RDEPEND="
	dev-libs/boost[threads]
	dev-libs/pugixml:=
	media-libs/ilmbase:=
	media-libs/libpng:0=
	>=media-libs/libwebp-0.2.1:=
	media-libs/openexr:=
	media-libs/tiff:0=
	sys-libs/zlib:=
	virtual/jpeg

	fast-sha1? ( dev-libs/openssl:0 )
	ffmpeg? ( >=virtual/ffmpeg-9 )
	gif? ( media-libs/giflib )
	jpeg2k? ( media-libs/openjpeg:0= )
	opencolorio? ( media-libs/opencolorio:= )
	opencv? ( >=media-libs/opencv-2.3:= )
	raw? ( media-libs/libraw:= )
	tools? (
		qt4? (
			dev-qt/qtcore:4= 
			dev-qt/qtgui:4=
			dev-qt/qtopengl:4=
			media-libs/glew:=
		    )
		)
	truetype? ( media-libs/freetype:2= )
"
# TODO: png, tiff, zlib, jpeg, webp should be controlled by flags

DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e 's/DOIIO_NO_SSE=1/DOIIO_SSE=1/' CMakeLists.txt
	sed -i -e 's/OpenImageIO\/pugixml/pugixml/' src/libOpenImageIO/xmp.cpp
	sed -i -e 's/OpenImageIO\/pugixml/pugixml/' src/libOpenImageIO/formatspec.cpp
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="/usr/$(get_libdir)"
		-DVERBOSE=ON
		-DOIIO_BUILD_TOOLS=$(usex tools ON OFF)
		-DOIIO_BUILD_TESTS=OFF
		-DBUILDSTATIC=OFF
		-DLINKSTATIC=OFF
		-DHIDE_SYMBOLS=ON
		-DNOTHREADS=$(usex threads OFF ON)
		-DOIIO_THREAD_ALLOW_DCLP=ON
		-DOIIO_BUILD_CPP11=OFF
		-DOIIO_BUILD_CPP14=OFF
		-DOIIO_BUILD_LIBCPLUSPLUS=OFF
		-DUSE_SIMD=0 # this enables SIMD instructions according to C{,XX}FLAGS
		-DUSE_EXTERNAL_PUGIXML=ON

		-DUSE_OPENGL=$(usex qt4 ON OFF)
		-DUSE_QT=$(usex qt4 ON OFF)
		-DFORCE_OPENGL_1=OFF
		-DUSE_PYTHON=OFF
		-DUSE_PYTHON3=OFF
		-DUSE_FIELD3D=OFF
		-DUSE_FFMPEG=$(usex ffmpeg ON OFF)
		-DUSE_OPENJPEG=$(usex jpeg2k ON OFF)
		-DUSE_OCIO=$(usex opencolorio ON OFF)
		-DUSE_OPENCV=$(usex opencv ON OFF)
		-DUSE_OPENSSL=$(usex fast-sha1 ON OFF)
		-DUSE_FREETYPE=$(usex truetype ON OFF)
		-DUSE_GIF=$(usex gif ON OFF)
		-DUSE_PTEX=OFF
		-DUSE_LIBRAW=$(usex raw ON OFF)
		-DUSE_NUKE=OFF
	)

	cmake-utils_src_configure
}

#set (EMBEDPLUGINS ON CACHE BOOL "Embed format plugins in libOpenImageIO")
#set (PYTHON_VERSION 2.6)
#set (PYTHON3_VERSION 3.2)
#set (Nuke_ROOT "" CACHE STRING "Where to find Nuke installation")
#set (NUKE_VERSION 7.0)
#set (PYLIB_INCLUDE_SONAME OFF CACHE BOOL "If ON, soname/soversion will be set for Python module library")
#set (PYLIB_LIB_PREFIX OFF CACHE BOOL "If ON, prefix the Python module with 'lib'")

src_install() {
	cmake-utils_src_install

	rm -rf "${ED}"/usr/share/doc
	dodoc {CHANGES,CREDITS,README*} # doc/CLA-{CORPORATE,INDIVIDUAL}
	docinto pdf
	dodoc src/doc/*.pdf
}
