RSYNC=rsync
RSYNC_FLAGS= -a --progress --delete --exclude=work

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
