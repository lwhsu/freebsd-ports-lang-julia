#!/bin/sh
pkg info openblas | grep INTERFACE64 | grep on > /dev/null && {
    echo "USE_BLAS64=		1" >> ${FILE}
} || {
    echo "USE_BLAS64=		0" >> ${FILE}
}
