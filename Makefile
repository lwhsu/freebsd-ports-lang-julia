# Created by: Li-Wen Hsu <lwhsu@FreeBSD.org>
# $FreeBSD$

PORTNAME=	julia
PORTVERSION=	0.2.1
CATEGORIES=	lang
MASTER_SITES=	${GITHUB_MASTER_SITE}/${GH_ACCOUNT}/${GH_PROJECT}/legacy.tar.gz/${GH_TAGNAME}?dummy=/
DISTFILES=	${DISTNAME}${EXTRACT_SUFX}

MAINTAINER=	lwhsu@FreeBSD.org
COMMENT=	The Julia Language: A fresh approach to technical computing

USES=	gmake

GITHUB_MASTER_SITE=	https://codeload.github.com

USE_GITHUB=	yes
GH_ACCOUNT=	JuliaLang
GH_PROJECT=	julia
GH_TAGNAME=	v${PORTVERSION}
GH_COMMIT=	7c5dea6
JULIA_COMMIT=	e44b593905

GITMODULES=	libuv openlibm Rmath JuliaDoc

libuv_GH_ACCOUNT=	${GH_ACCOUNT}
libuv_GH_PROJECT=	libuv
libuv_GH_COMMIT=	4c58385
libuv_PATH=	deps/libuv
libuv_DISTNAME=	${libuv_GH_ACCOUNT}-${libuv_GH_PROJECT}-${libuv_GH_COMMIT}
MASTER_SITES+=	${GITHUB_MASTER_SITE}/${libuv_GH_ACCOUNT}/${libuv_GH_PROJECT}/legacy.tar.gz/${libuv_GH_COMMIT}?dummy=/:libuv
DISTFILES+=	${libuv_DISTNAME}${EXTRACT_SUFX}:libuv

openlibm_GH_ACCOUNT=	${GH_ACCOUNT}
openlibm_GH_PROJECT=	openlibm
openlibm_GH_COMMIT=da6c9c1
openlibm_PATH=	deps/openlibm
openlibm_DISTNAME=	${openlibm_GH_ACCOUNT}-${openlibm_GH_PROJECT}-${openlibm_GH_COMMIT}
MASTER_SITES+=	${GITHUB_MASTER_SITE}/${openlibm_GH_ACCOUNT}/${openlibm_GH_PROJECT}/legacy.tar.gz/${openlibm_GH_COMMIT}?dummy=/:openlibm
DISTFILES+=	${openlibm_DISTNAME}${EXTRACT_SUFX}:openlibm

Rmath_GH_ACCOUNT=	${GH_ACCOUNT}
Rmath_GH_PROJECT=	Rmath
Rmath_GH_COMMIT=	226598f
Rmath_PATH=	deps/Rmath
Rmath_DISTNAME=	${Rmath_GH_ACCOUNT}-${Rmath_GH_PROJECT}-${Rmath_GH_COMMIT}
MASTER_SITES+=	${GITHUB_MASTER_SITE}/${Rmath_GH_ACCOUNT}/${Rmath_GH_PROJECT}/legacy.tar.gz/${Rmath_GH_COMMIT}?dummy=/:Rmath
DISTFILES+=	${Rmath_DISTNAME}${EXTRACT_SUFX}:Rmath

JuliaDoc_GH_ACCOUNT=	${GH_ACCOUNT}
JuliaDoc_GH_PROJECT=	JuliaDoc
JuliaDoc_GH_COMMIT=91ca0bf
JuliaDoc_PATH=	doc/juliadoc
JuliaDoc_DISTNAME=	${JuliaDoc_GH_ACCOUNT}-${JuliaDoc_GH_PROJECT}-${JuliaDoc_GH_COMMIT}
MASTER_SITES+=	${GITHUB_MASTER_SITE}/${JuliaDoc_GH_ACCOUNT}/${JuliaDoc_GH_PROJECT}/legacy.tar.gz/${JuliaDoc_GH_COMMIT}?dummy=/:JuliaDoc
DISTFILES+=	${JuliaDoc_DISTNAME}${EXTRACT_SUFX}:JuliaDoc

.include <bsd.port.pre.mk>

post-extract:
.for module in ${GITMODULES}
	@${MV} ${WRKDIR}/${${module}_DISTNAME}/* ${WRKSRC}/${${module}_PATH}/
.endfor

post-patch:
	@${REINPLACE_CMD} -e 's,JULIA_COMMIT.*,JULIA_COMMIT=${JULIA_COMMIT},' ${WRKSRC}/Make.inc

.include <bsd.port.post.mk>
