--- Make.inc.orig	2016-06-19 17:16:52 UTC
+++ Make.inc
@@ -301,8 +301,8 @@ SHIPFLAGS = -O3 -ggdb3 -falign-functions
 endif
 
 ifeq ($(USECLANG),1)
-CC = $(CROSS_COMPILE)clang
-CXX = $(CROSS_COMPILE)clang++
+CC ?= $(CROSS_COMPILE)clang
+CXX ?= $(CROSS_COMPILE)clang++
 JCFLAGS = -pipe $(fPIC) -fno-strict-aliasing -D_FILE_OFFSET_BITS=64
 JCPPFLAGS =
 JCXXFLAGS = -pipe $(fPIC) -fno-rtti
@@ -318,6 +318,8 @@ CC += $(STDLIBCPP_FLAG) -mmacosx-version
 CXX += $(STDLIBCPP_FLAG) -mmacosx-version-min=10.6
 endif
 JCPPFLAGS += -D_LARGEFILE_SOURCE -D_DARWIN_USE_64_BIT_INODE=1
+else ifeq ($(OS), FreeBSD)
+CXX += -stdlib=libc++ -std=c++11
 endif
 endif
 
@@ -472,11 +474,13 @@ else
 XC_HOST := $(ARCH)$(shell echo $(BUILD_MACHINE) | sed "s/[^-]*\(.*\)$$/\1/")
 MARCH = $(ARCH)
 endif
+ifeq ($(BUILD_OS),FreeBSD)
+ifeq ($(ARCH),amd64)
+MARCH = x86-64
+endif
+endif
 
 ifneq ($(MARCH),)
-CC += -march=$(MARCH)
-CXX += -march=$(MARCH)
-FC += -march=$(MARCH)
 JULIA_CPU_TARGET ?= $(MARCH)
 ifeq ($(OS),Darwin)
 # on Darwin, the standalone `as` program doesn't know
@@ -662,7 +666,7 @@ endif
 
 ifeq ($(USE_SYSTEM_UTF8PROC), 1)
   LIBUTF8PROC = -lutf8proc
-  UTF8PROC_INC = /usr/include
+  UTF8PROC_INC = /usr/local/include
 else
   LIBUTF8PROC = $(build_libdir)/libutf8proc.a
   UTF8PROC_INC = $(build_includedir)
