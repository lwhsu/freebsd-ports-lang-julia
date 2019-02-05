--- deps/blas.mk.orig	2019-02-06 00:40:20.032286000 +0800
+++ deps/blas.mk	2019-02-06 00:44:36.622010000 +0800
@@ -95,6 +95,8 @@
 ifneq ($(USE_BINARYBUILDER_OPENBLAS), 1)
 
 $(BUILDDIR)/$(OPENBLAS_SRC_DIR)/build-configured: $(BUILDDIR)/$(OPENBLAS_SRC_DIR)/source-extracted
+	cd $(BUILDDIR)/$(OPENBLAS_SRC_DIR) && \
+		patch -p1 -f < $(SRCDIR)/patches/openblas-fix-arch.patch
 	echo 1 > $@
 
 $(BUILDDIR)/$(OPENBLAS_SRC_DIR)/build-compiled: $(BUILDDIR)/$(OPENBLAS_SRC_DIR)/build-configured
