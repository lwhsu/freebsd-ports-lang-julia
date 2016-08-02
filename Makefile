# Created by: Li-Wen Hsu <lwhsu@FreeBSD.org>
# $FreeBSD$

PORTNAME=	julia
PORTVERSION=	0.4.6
DISTVERSIONPREFIX=	v
CATEGORIES=	lang math
MASTER_SITES=	GH

MAINTAINER=	iblis@hs.ntnu.edu.tw
COMMENT=	The Julia Language: A fresh approach to technical computing

USES=	gmake compiler:c++11-lib fortran

USE_GITHUB=	yes
GH_ACCOUNT=	JuliaLang
GH_PROJECT=	julia
GH_TUPLE=	JuliaLang:libuv:efb4076:libuv \
		JuliaLang:Rmath-julia:v0.1:Rmath \
		JuliaLang:openspecfun:381db9b:openspecfun

LIB_DEPENDS=	libarpack.so:math/arpack-ng \
		libgit2.so:devel/libgit2 \
		libutf8proc.so:textproc/utf8proc \
		libopenblas.so:math/openblas

BUILD_DEPENDS=	llvm-config37:devel/llvm37 \
		pcre2-config:devel/pcre2 \
		patchelf:sysutils/patchelf

DISTNAME_libunwind=	libunwind-1.1
WRKSRC_libunwind=	${WRKDIR}/${DISTNAME_libunwind}
MASTER_SITES+=	http://download.savannah.gnu.org/releases/libunwind/:libunwind
DISTFILES+=	${DISTNAME_libunwind}${EXTRACT_SUFX}:libunwind

DISTNAME_dSFMT=	dSFMT-src-2.2.3
WRKSRC_dSFMT=	${WRKDIR}/${DISTNAME_dSFMT}
MASTER_SITES+=	http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/:dSFMT
DISTFILES+=	${DISTNAME_dSFMT}${EXTRACT_SUFX}:dSFMT

MAKE_ARGS=	prefix=${PREFIX}

TEST_TARGET=	test

post-extract:
	${MKDIR} -p ${WRKSRC}/doc/_build/html
	(cd ${WRKSRC}/deps && ln -s ${WRKSRC_Rmath} Rmath)
	(cd ${WRKSRC}/deps && ln -s ${WRKSRC_libuv} libuv)
	(cd ${WRKSRC}/deps && ln -s ${WRKSRC_openspecfun} openspecfun)
	(cd ${WRKSRC}/deps && ln -s ${WRKSRC_libunwind} libunwind)
	(cd ${WRKSRC}/deps && ln -s ${WRKSRC_dSFMT} dsfmt)

.include <bsd.port.pre.mk>

MAKE_CMD=	LD_LIBRARY_PATH=/usr/local/lib/gcc48 gmake

.include <bsd.port.post.mk>
