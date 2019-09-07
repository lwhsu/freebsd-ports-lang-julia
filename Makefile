RSYNC=	rsync
RSYNC_FLAGS=	-a --progress --delete --exclude=work

POUDRIERE=	sudo poudriere
POUDRIERE_FLAGS=testport -p dev -w

PORTSTREE?=	/home/iblis/ports/dev

all: julia julia07 julia06 julia10 julia11 julia12

.PHONY: julia
julia:
	${RSYNC} ${RSYNC_FLAGS} julia/ ${PORTSTREE}/lang/julia/

.PHONY: julia06 julia07 julia10 julia11 julia12
julia06 julia07 julia10 julia11 julia12:
	${RSYNC} ${RSYNC_FLAGS} ${.TARGET}/ ${PORTSTREE}/lang/${.TARGET}/

.PHONY: options
options:
	sudo ln -sfF ${PWD}/options/openblas /usr/local/etc/poudriere.d/openblas-options
	sudo ln -sfF ${PWD}/options/jlall /usr/local/etc/poudriere.d/jlall-options
	sudo ln -sfF ${PWD}/options/syslibm /usr/local/etc/poudriere.d/syslibm-options

PORTNAME=	${.TARGET:S/test-//}

test-julia06 test-julia07 test-julia10 test-julia11 test-julia12: ${.TARGET:S/test-//} options
.for jail in 120r 120r-i386 112r 112r-i386
	${POUDRIERE} ${POUDRIERE_FLAGS} -j ${jail} -o lang/${PORTNAME}
.for set in openblas syslibm jlall
	${POUDRIERE} ${POUDRIERE_FLAGS} -j ${jail} -o lang/${PORTNAME} -z ${set}
.endfor
.endfor

test-julia: all
.for jail in 120r 120r-i386 112r 112r-i386
	${POUDRIERE} ${POUDRIERE_FLAGS} -j ${jail} -o lang/julia
.endfor


sync-portstree:
	${RSYNC} ${RSYNC_FLAGS} ${PORTSTREE}/lang/julia06/ julia06/
	${RSYNC} ${RSYNC_FLAGS} ${PORTSTREE}/lang/julia07/ julia07/
	${RSYNC} ${RSYNC_FLAGS} ${PORTSTREE}/lang/julia10/ julia10/
	${RSYNC} ${RSYNC_FLAGS} ${PORTSTREE}/lang/julia11/ julia11/
	${RSYNC} ${RSYNC_FLAGS} ${PORTSTREE}/lang/julia/   julia/
