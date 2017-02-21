commit 22790b1aa40c0bc1e735fff65a07882e257f0050
Author: Iblis Lin <iblis@hs.ntnu.edu.tw>
Date:   Sun Feb 19 15:47:29 2017 +0800

    libdl: implement dllist on FreeBSD
    
    DL_ITERATE_PHDR(3):
    https://www.freebsd.org/cgi/man.cgi?query=dl_iterate_phdr&apropos=0&sektion=3&manpath=FreeBSD+12-current&arch=default&format=html

diff --git base/libdl.jl.orig base/libdl.jl
index a9e6568470..e89c8a5a8d 100644
--- base/libdl.jl.orig
+++ base/libdl.jl
@@ -205,6 +205,31 @@ if is_linux()
     end
 end # linux-only
 
+if is_bsd() && !is_apple()
+    # DL_ITERATE_PHDR(3) on freebsd
+    struct dl_phdr_info
+        # Base address of object
+        addr::Cuint
+
+        # Null-terminated name of object
+        name::Ptr{UInt8}
+
+        # Pointer to array of ELF program headers for this object
+        phdr::Ptr{Void}
+
+        # Number of program headers for this object
+        phnum::Cshort
+    end
+
+    function dl_phdr_info_callback(di::dl_phdr_info, size::Csize_t, dy_libs::Array{AbstractString,1})
+        name = unsafe_string(di.name)
+        if !isempty(name)
+            push!(dy_libs, name)
+        end
+        return convert(Cint, 0)::Cint
+    end
+end # bsd family
+
 function dllist()
     dynamic_libraries = Array{AbstractString}(0)
 
@@ -228,6 +253,13 @@ function dllist()
         ccall(:jl_dllist, Cint, (Any,), dynamic_libraries)
     end
 
+    @static if is_bsd() && !is_apple()
+        const callback = cfunction(dl_phdr_info_callback, Cint,
+                                   (Ref{dl_phdr_info}, Csize_t, Ref{Array{AbstractString,1}} ))
+        ccall(:dl_iterate_phdr, Cint, (Ptr{Void}, Ref{Array{AbstractString,1}}), callback, dynamic_libraries)
+        shift!(dynamic_libraries)
+    end
+
     return dynamic_libraries
 end
 
