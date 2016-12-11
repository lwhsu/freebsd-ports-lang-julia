--- Make.inc.orig	2016-09-20 02:54:21 UTC
+++ Make.inc
@@ -128,12 +128,7 @@ endif
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
@@ -400,7 +395,7 @@ JCFLAGS := -pipe $(fPIC) -fno-strict-ali
 JCPPFLAGS := -fasynchronous-unwind-tables
 JCXXFLAGS := -pipe $(fPIC) -fno-rtti -pedantic
 DEBUGFLAGS := -O0 -g -DJL_DEBUG_BUILD -fstack-protector-all
-SHIPFLAGS := -O3 -g
+SHIPFLAGS := -O3
 ifeq ($(OS), Darwin)
 ifeq ($(USE_LIBCPP), 1)
 CC += -stdlib=libc++ -mmacosx-version-min=10.7
@@ -832,7 +827,7 @@ endif
 
 ifeq ($(USE_SYSTEM_UTF8PROC), 1)
   LIBUTF8PROC := -lutf8proc
-  UTF8PROC_INC := /usr/include
+  UTF8PROC_INC := $(LOCALBASE)/include
 else
   LIBUTF8PROC := $(build_libdir)/libutf8proc.a
   UTF8PROC_INC := $(build_includedir)
