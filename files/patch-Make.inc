--- Make.inc.orig	2014-07-25 04:23:36.745186638 +0800
+++ Make.inc	2014-07-25 04:23:37.135186798 +0800
@@ -162,6 +162,11 @@
 endif
 endif
 
+ifeq ($(OS), FreeBSD)
+USEGCC = 0
+USECLANG = 1
+endif
+
 FC = $(CROSS_COMPILE)gfortran
 
 ifeq ($(USEGCC),1)
@@ -233,6 +238,11 @@
 endif
 endif
 
+# We map amd64 to x86_64 for compatibility with systems that identify 64-bit systems as such
+ifeq ($(ARCH),amd64)
+override ARCH = x86_64
+endif
+
 ifeq ($(USEGCC),1)
 ifneq ($(ARCH), ppc64)
   SHIPFLAGS += -momit-leaf-frame-pointer
