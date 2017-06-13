--- base/sharedarray.jl.orig	2017-05-08 07:00:02 UTC
+++ base/sharedarray.jl
@@ -477,13 +477,7 @@ complex(S1::SharedArray,S2::SharedArray)
 
 function print_shmem_limits(slen)
     try
-        if is_linux()
-            pfx = "kernel"
-        elseif is_apple()
-            pfx = "kern.sysv"
-        else
-            return
-        end
+        pfx = "kern.ipc"
 
         shmmax_MB = div(parse(Int, split(readstring(`sysctl $(pfx).shmmax`))[end]), 1024*1024)
         page_size = parse(Int, split(readstring(`getconf PAGE_SIZE`))[end])
