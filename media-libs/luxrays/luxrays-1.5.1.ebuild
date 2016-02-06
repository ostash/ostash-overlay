# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

#inherit eutils
inherit cmake-utils vcs-snapshot

DESCRIPTION="An open source component for accelerating any ray tracing application"
HOMEPAGE="http://www.luxrender.net/wiki/LuxRays"
EHG_REVISION="8577ff287efb"
SRC_URI="https://bitbucket.org/luxrender/luxrays/get/luxrender_v${PV}.tar.bz2"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64"

#IUSE="gnome X"

#RESTRICT="strip"

RDEPEND="
	dev-libs/boost[threads]
	media-libs/embree:=
	media-libs/freeglut:=
	media-libs/glew:=
	media-libs/openexr:=
	media-libs/openimageio:=

	media-libs/libpng:=
	media-libs/tiff:=
	virtual/jpeg
"
# cl
# openmp
# bison, flex
# doxygen

# TODO: glew, libpng, tiff and jpeg are not needed, but searched by build system

	#include <GL/glx.h>
	#Python.h

	#include <CL/cl.hpp>
#"

DEPEND="${RDEPEND}"

S=${WORKDIR}/luxrender_v${PV}

#CMAKE_IN_SOURCE_BUILD=1

src_prepare() {
	default
	epatch ${FILESDIR}/${PN}-clean-flags.patch
	epatch ${FILESDIR}/${PN}-disable-boost-locale.patch
	sed -i -e '/LUXRAYS_BOOST_COMPONENTS/s/python//' cmake/Dependencies.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DLUXRAYS_DISABLE_OPENCL=ON
	)
	cmake-utils_src_configure
}

#if (NOT OPENCL_FOUND AND NOT LUXRAYS_DISABLE_OPENCL)
#if (NOT OPENGL_FOUND AND NOT LUXRAYS_DISABLE_OPENCL)
#	MESSAGE(ERROR "--> Could not locate required OpenGL files, disabling OpenCL support, disabling samples build")
#	SET(LUXRAYS_DISABLE_OPENCL 1)
#if (NOT GLEW_FOUND)
#if (NOT GLUT_FOUND)
#if (LUXRAYS_DISABLE_OPENCL)
#	ADD_DEFINITIONS("-DLUXRAYS_DISABLE_OPENCL")


# The following src_compile function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
#src_compile() {
	# emake is a script that calls the standard GNU make with parallel
	# building options for speedier builds (especially on SMP systems).
	# Try emake first.  It might not work for some packages, because
	# some makefiles have bugs related to parallelism, in these cases,
	# use emake -j1 to limit make to a single process.  The -j1 is a
	# visual clue to others that the makefiles have bugs that have been
	# worked around.

	#emake
#}

# The following src_install function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
#src_install() {
	# You must *personally verify* that this trick doesn't install
	# anything outside of DESTDIR; do this by reading and
	# understanding the install part of the Makefiles.
	# This is the preferred way to install.
	#emake DESTDIR="${D}" install

	# When you hit a failure with emake, do not just use make. It is
	# better to fix the Makefiles to allow proper parallelization.
	# If you fail with that, use "emake -j1", it's still better than make.

	# For Makefiles that don't make proper use of DESTDIR, setting
	# prefix is often an alternative.  However if you do this, then
	# you also need to specify mandir and infodir, since they were
	# passed to ./configure as absolute paths (overriding the prefix
	# setting).
	#emake \
	#	prefix="${D}"/usr \
	#	mandir="${D}"/usr/share/man \
	#	infodir="${D}"/usr/share/info \
	#	libdir="${D}"/usr/$(get_libdir) \
	#	install
	# Again, verify the Makefiles!  We don't want anything falling
	# outside of ${D}.
#}
