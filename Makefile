RSYNC=	rsync
RSYNC_FLAGS=	-a --progress --delete --exclude=work

POUDRIERE=	sudo poudriere
POUDRIERE_FLAGS=testport -p dev -w

all: julia julia10 julia11

.PHONY: julia
julia:
	${RSYNC} ${RSYNC_FLAGS} julia/ /usr/ports/lang/julia/

.PHONY: julia10
julia10:
	${RSYNC} ${RSYNC_FLAGS} julia10/ /usr/ports/lang/julia10/

.PHONY: julia11
julia11:
	${RSYNC} ${RSYNC_FLAGS} julia11/ /usr/ports/lang/julia11/

.PHONY: options
options:
	sudo ln -sf ${PWD}/options/openblas /usr/local/etc/poudriere.d/openblas-options
	sudo ln -sf ${PWD}/options/jlall /usr/local/etc/poudriere.d/jlall-options

PORTNAME=	${.TARGET:S/test-//}

test-julia11 test-julia10: ${.TARGET:S/test-//} options
.for jail in 120r 120r-i386 112r 112r-i386
	${POUDRIERE} ${POUDRIERE_FLAGS} -j ${jail} -o lang/${PORTNAME}
	${POUDRIERE} ${POUDRIERE_FLAGS} -j ${jail} -o lang/${PORTNAME} -z openblas
	${POUDRIERE} ${POUDRIERE_FLAGS} -j ${jail} -o lang/${PORTNAME} -z jlall
.endfor
