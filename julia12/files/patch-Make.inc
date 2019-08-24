--- Make.inc.orig	2019-08-20 08:05:52.000000000 +0800
+++ Make.inc	2019-08-20 09:10:12.120676000 +0800
@@ -136,12 +136,7 @@
 # disable automatic Makefile rules
 .SUFFIXES:
 
-# find out if git repository is available
-ifeq ($(shell [ -e $(JULIAHOME)/.git ] && echo true || echo "Warning: git information unavailable; versioning information limited" >&2), true)
-NO_GIT := 0
-else
 NO_GIT := 1
-endif
 
 # Julia's Semantic Versioning system labels the three decimal places in a version number as
 # the major, minor and patch versions.  Typically the major version would be incremented
@@ -191,7 +186,7 @@
 libexecdir := $(prefix)/libexec
 datarootdir := $(prefix)/share
 docdir := $(datarootdir)/doc/julia
-mandir := $(datarootdir)/man
+mandir := $(prefix)/man
 man1dir := $(mandir)/man1
 includedir := $(prefix)/include
 sysconfdir := $(prefix)/etc
@@ -204,7 +199,7 @@
 build_libdir := $(build_prefix)/lib
 build_libexecdir := $(build_prefix)/libexec
 build_datarootdir := $(build_prefix)/share
-build_mandir := $(build_datarootdir)/man
+build_mandir := $(build_prefix)/man
 build_man1dir := $(build_mandir)/man1
 build_includedir := $(build_prefix)/include
 build_sysconfdir := $(build_prefix)/etc
@@ -359,7 +354,7 @@
 ifeq ($(USEIFC), 1)
 FC := ifort
 else
-FC := $(CROSS_COMPILE)gfortran
+FC ?= $(CROSS_COMPILE)gfortran
 endif
 
 STDLIBCPP_FLAG :=
@@ -412,8 +407,8 @@
 endif
 
 ifeq ($(USECLANG),1)
-CC := $(CROSS_COMPILE)clang
-CXX := $(CROSS_COMPILE)clang++
+CC ?= $(CROSS_COMPILE)clang
+CXX ?= $(CROSS_COMPILE)clang++
 JCFLAGS := -pipe $(fPIC) -fno-strict-aliasing -D_FILE_OFFSET_BITS=64
 # AArch64 needs this flag to generate the .eh_frame used by libunwind
 JCPPFLAGS := -fasynchronous-unwind-tables
@@ -928,16 +923,7 @@
   UTF8PROC_INC := $(build_includedir)
 endif
 
-# BinaryBuilder options.  We default to "on" for all the projects listed in BB_PROJECTS,
-# but only if contrib/normalize_triplet.py works for our requested triplet.
-ifeq ($(shell python $(JULIAHOME)/contrib/normalize_triplet.py $(or $(XC_HOST),$(XC_HOST),$(BUILD_MACHINE)) >/dev/null 2>/dev/null; echo $$?),0)
-USE_BINARYBUILDER := 1
-else
-ifneq ($(shell python $(JULIAHOME)/contrib/normalize_triplet.py x86_64-linux-gnu),x86_64-linux-gnu)
-$(warning python normalize_triplet.py appears to be non-functional, so BinaryBuilder disabled)
-endif
 USE_BINARYBUILDER := 0
-endif
 
 # GMP and MPFR have serious performance regressions for now
 USE_BINARYBUILDER_GMP ?= 0
