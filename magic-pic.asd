(asdf:defsystem magic-pic
  :version "0.0.1"
  :author "ZiHao Zhou <1042181618@qq.com>"
  :description "magic-pic is a Common Lisp library to change png to a string txt file."
  :licence "BSD-style"
  :depends-on (:png-read)
  :components ((:file "package")
               (:file "matrix" :depends-on ("package"))))
