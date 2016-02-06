# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="High Performance Ray Tracing Kernels"
HOMEPAGE="https://embree.github.io/"
SRC_URI="https://github.com/embree/embree/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64"

IUSE="ispc tbb cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2"

# I didn't manage to compile AVX512 support with GCC 5.3, looks like ICC required

# Other features/tunables to consider in use flags:
# ENABLE_STATIC_LIB : static-libs
# ENABLE_TUTORIALS : examples
# ENABLE_XEON_PHI_SUPPORT : requires ICC and Intel® MPSS

# RTCORE_STAT_COUNTERS : Enables statistic counters (disabled)
# RTCORE_RAY_MASK : Enables ray mask support (disabled)
# RTCORE_BACKFACE_CULLING : Enables backface culling (disabled)
# RTCORE_INTERSECTION_FILTER : Enables intersection filter callback (enabled)
# RTCORE_INTERSECTION_FILTER_RESTORE : Restores previous hit when hit is filtered out (enabled)
# RTCORE_BUFFER_STRIDE : Enables buffer strides (enabled)
# RTCORE_ENABLE_RAYSTREAM_LOGGER : Enables ray stream logger (disabled)
# RTCORE_IGNORE_INVALID_RAYS : Ignores invalid rays (disabled)
# RTCORE_RAY_PACKETS : Enabled support for ray packets (enabled)

RDEPEND="
	tbb? ( dev-cpp/tbb )
"

DEPEND="${RDEPEND}
	ispc? ( dev-lang/ispc )
"

src_unpack() {
	default
	epatch ${FILESDIR}/embree-allow-configure-targets.patch
}

src_configure() {
	local xeon_isa="SSE2"
	use cpu_flags_x86_sse4_2 && xeon_isa="${xeon_isa};SSE4.2"
	use cpu_flags_x86_avx && xeon_isa="${xeon_isa};AVX"
	use cpu_flags_x86_avx2 && xeon_isa="${xeon_isa};AVX2"

	local mycmakeargs=(
		-DENABLE_ISPC_SUPPORT=$(usex ispc ON OFF)
		-DRTCORE_TASKING_SYSTEM=$(usex tbb TBB INTERNAL)
		-DENABLE_TUTORIALS=OFF
		-DXEON_ISA=${xeon_isa}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# Tutorials data files are installed to /usr/bin regardless to ENABLE_TUTORIALS
	rm -fr "${ED}/usr/bin"
	# Docs are installed to wrong folder,
	rm -fr "${ED}/usr/share/doc/embree2"
	# install them manually
	dodoc CHANGELOG.md LICENSE.txt readme.pdf
}
