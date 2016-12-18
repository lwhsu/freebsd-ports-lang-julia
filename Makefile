# Created by: Li-Wen Hsu <lwhsu@FreeBSD.org>
# $FreeBSD$

PORTNAME=	julia
PORTVERSION=	0.5.0
DISTVERSIONSUFFIX=	-full
CATEGORIES=	lang math
MASTER_SITES=	https://github.com/JuliaLang/julia/releases/download/v${PORTVERSION}/

MAINTAINER=	iblis@hs.ntnu.edu.tw
COMMENT=	Julia programming Language: A fresh approach to technical computing

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE.md

LIB_DEPENDS=	libunwind.so:devel/libunwind \
		libutf8proc.so:textproc/utf8proc \
		libopenblas.so:math/openblas \
		libgit2.so:devel/libgit2 \
		libgmp.so:math/gmp \
		libmpfr.so:math/mpfr
BUILD_DEPENDS=	llvm-config38:devel/llvm38 \
		pcre2-config:devel/pcre2 \
		patchelf:sysutils/patchelf

ONLY_FOR_ARCHS=	amd64

USES=	gmake compiler:c++11-lib fortran
USE_LDCONFIG=	yes

WRKSRC=	${WRKDIR}/${PORTNAME}-${PORTVERSION}

ALL_TARGET=	default
INSTALL_TARGET=	install
TEST_TARGET=	test

CXXFLAGS+=	-stdlib=libc++ -std=c++11
MAKE_ARGS+=	prefix=${PREFIX} JCXXFLAGS="${CXXFLAGS}" \
		FORCE_ASSERTIONS=${FORCE_ASSERTIONS} \
		USE_GPL_LIBS=${USE_GPL_LIBS}

OPTIONS_DEFINE=	EXAMPLES DEBUG DOCS GPL_LIBS DESKTOP
OPTIONS_SUB=	yes

DEBUG_VARS=	FORCE_ASSERTIONS=1 \
		ALL_TARGET=all

PORTDOCS=	html
DOCS_VARS=	INSTALL_TARGET+=install-docs

PORTEXAMPLES=	*
EXAMPLES_VARS=	INSTALL_TARGET+=install-examples

GPL_LIBS_DESC=	Build with GPL libs: FFTW and SUITESPARSE
GPL_LIBS_LIB_DEPENDS=	libfftw3.so:math/fftw3 \
			libfftw3f.so:math/fftw3-float \
			libumfpack.so:math/suitesparse
GPL_LIBS_VARS=	USE_GPL_LIBS=1

DESKTOP_DESC=	Install icon, .desktop and appdata file
DESKTOP_VARS=	INSTALL_TARGET+=install-desktop \
		INSTALLS_ICONS=yes

post-patch:
	/usr/bin/env FILE=${WRKSRC}/Make.user ${SCRIPTDIR}/check_openblas.sh

.include <bsd.port.mk>
