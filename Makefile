# Created by: Li-Wen Hsu <lwhsu@FreeBSD.org>
# $FreeBSD$

PORTNAME=	julia
PORTVERSION=	0.5.0
DISTVERSIONSUFFIX=	-full
CATEGORIES=	lang math
MASTER_SITES=	https://github.com/JuliaLang/julia/releases/download/v${PORTVERSION}/

MAINTAINER=	iblis@hs.ntnu.edu.tw
COMMENT=	The Julia Language: A fresh approach to technical computing

USES=	gmake compiler:c++11-lib fortran

WRKSRC=	${WRKDIR}/${PORTNAME}-${PORTVERSION}

# GH_TUPLE=	JuliaLang:libuv:efb4076:libuv \
# 		JuliaLang:Rmath-julia:v0.1:Rmath \
# 		JuliaLang:openspecfun:381db9b:openspecfun
#
# LIB_DEPENDS=	libarpack.so:math/arpack-ng \
# 		libgit2.so:devel/libgit2 \
# 		libutf8proc.so:textproc/utf8proc \
# 		libopenblas.so:math/openblas
#
BUILD_DEPENDS=	llvm-config38:devel/llvm38 \
		pcre2-config:devel/pcre2 \
		patchelf:sysutils/patchelf
#
# DISTNAME_libunwind=	libunwind-1.1
# WRKSRC_libunwind=	${WRKDIR}/${DISTNAME_libunwind}
# MASTER_SITES+=	http://download.savannah.gnu.org/releases/libunwind/:libunwind
# DISTFILES+=	${DISTNAME_libunwind}${EXTRACT_SUFX}:libunwind
#
# DISTNAME_dSFMT=	dSFMT-src-2.2.3
# WRKSRC_dSFMT=	${WRKDIR}/${DISTNAME_dSFMT}
# MASTER_SITES+=	http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/:dSFMT
# DISTFILES+=	${DISTNAME_dSFMT}${EXTRACT_SUFX}:dSFMT
#


TEST_TARGET=	test
#
# post-extract:
# 	${MKDIR} -p ${WRKSRC}/doc/_build/html
# 	(cd ${WRKSRC}/deps && ln -s ${WRKSRC_Rmath} Rmath)
# 	(cd ${WRKSRC}/deps && ln -s ${WRKSRC_libuv} libuv)
# 	(cd ${WRKSRC}/deps && ln -s ${WRKSRC_openspecfun} openspecfun)
# 	(cd ${WRKSRC}/deps && ln -s ${WRKSRC_libunwind} libunwind)
# 	(cd ${WRKSRC}/deps && ln -s ${WRKSRC_dSFMT} dsfmt)

CXXFLAGS+=	-stdlib=libc++ -std=c++11
MAKE_ARGS+=	prefix=${PREFIX} JCXXFLAGS="${CXXFLAGS}" FORCE_ASSERTIONS=1

.include <bsd.port.pre.mk>

# MAKE_CMD=	gmake prefix=${PREFIX}

.include <bsd.port.post.mk>
