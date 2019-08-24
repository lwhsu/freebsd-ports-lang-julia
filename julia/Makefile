# Created by: Iblis Lin <iblis@hs.ntnu.edu.tw>
# $FreeBSD$

PORTNAME=	julia
PORTVERSION=	1.0.4
CATEGORIES=	lang math
MASTER_SITES=	# empty
DISTFILES=	# empty
EXTRACT_ONLY=	# empty

MAINTAINER=	iblis@hs.ntnu.edu.tw
COMMENT=	Meta port for the different versions of Julia compiler

# LICENSE=	# empty
# LICENSE_FILE=	# empty

ONLY_FOR_ARCHS=	amd64 i386

NO_BUILD=	yes

PLIST_FILES=	bin/julia \
		man/man1/julia.1.gz\
		etc/julia

OPTIONS_DEFAULT=	V${JULIA_DEFAULT:S/.//} D${JULIA_DEFAULT:S/.//}
OPTIONS_SINGLE=	DEFAULTVER

.for v in 06 07 10 11 12
OPTIONS_DEFINE+=	V${v}
OPTIONS_SINGLE_DEFAULTVER+=	D${v}  # D stands for default

V${v}_DESC=	Install v${:!${MAKE} -C ${PORTSDIR}/lang/julia${v} -v PORTVERSION!} release
V${v}_RUN_DEPENDS=	julia${v}:lang/julia${v}

D${v}_IMPLIES=	V${v}
.endfor

DEFAULTVER_DESC=	Select default version
D06_DESC=	Please select a version for setting up symbolic links of
D07_DESC=	bin/julia, manpage and etc/startup.jl.


.include <bsd.port.options.mk>

_JULIA_VER=	${PORT_OPTIONS:MD*:S/D//}

do-install:
	${RLN} julia${_JULIA_VER} ${STAGEDIR}${PREFIX}/bin/julia
	${RLN} ../julia/julia${_JULIA_VER}/etc/julia ${STAGEDIR}${PREFIX}/etc
	${RLN} julia${_JULIA_VER}.1.gz ${STAGEDIR}${PREFIX}/man/man1/julia.1.gz

.include <bsd.port.mk>
