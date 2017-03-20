(in-package :magic-pic)
;;(ql:quickload "png-read")

(defparameter *png-object* nil)

(defun set-png-object (file)
  (setf *png-object* (png-read:read-png-file file)))

;; todo can be improve
(defun print-png-info ()
      (let ((width (png-read:width *png-object*))
            (height (png-read:height *png-object*))
            (bit-depth (png-read:bit-depth *png-object*)))
        (format t "width: ~A~%height: ~A~%bit-depth: ~A~%" width height bit-depth)))

(defun save-image-data (&optional (file "test"))
  (with-open-file (out file
                       :direction :output
                       :if-exists :supersede)
    (print (png-read:image-data *png-object*) out)))

(defun check-object-and-do-funcation (fn)
  (if (eql nil *png-object*)
      (format t "we never hava png-object.please use funcation (set-png-object *file*) to set frist")
      (funcall fn)))

(defun safe-print-png-info ()
  (check-object-and-do-funcation #'print-png-info))

(defun safe-save-image-data ()
  (check-object-and-do-funcation #'save-image-data))

;; 这里使用匿名函数是重复的
(defun get-size ()
  (let ((fn #'(lambda () (list (png-read:width *png-object*) (png-read:height *png-object*)))))
    (check-object-and-do-funcation fn)))

(defun png->bitmap ()
  (let ((image (png-read:image-data *png-object*))
        (bitmap (make-array (get-size) :initial-element 0)));; 接下来应该循环这个数组了
    (dotimes (i (png-read:width *png-object*))
      (dotimes (j (png-read:height *png-object*))
        (let ((s 0))
          (dotimes (k 3)
            (setf s (+ s (aref image i j k))))
          (setf (aref bitmap i j) (round (/ s 60))))))
    bitmap))
;; safe-png->bitmap

(defun safe-png->bitmap ()
  (check-object-and-do-funcation #'png->bitmap))


;;现在需要设计算法解决这个问题
;; 怎样保留图片中更多的文理  要保证 我们使用的 像素点和 字符匹配的差不多一致比如‘#’中正好和某个图形的位图一致
;; 那么怎么获取一个文字默认字体下的位图信息呢？ 可以获取输入文本的字体的位图吗？
;; 这里使用最简单的分级转化 算法

;; 现在需要一个映射关系 0-255 => 0->20  也就是 0到19的对应关系表
;;  . , _ - ~ : ! + = a 0 b % E H V & # M @

;; 这个定义一定是可以使使用 宏的~~ 这需要改造 a 0 b % E H V & # M @
(defun get-string (i)
  (case i
    (19 ".")
    (18 ",")
    (17 "_")
    (16 "-")
    (15 "~")
    (14 ":")
    (13 "!")
    (12 "+")
    (11 "=")
    (10 "a")
    (9 "0")
    (8 "b")
    (7 "%")
    (6 "V")
    (5 "H")
    (4 "E")
    (3 "&")
    (2 "#")
    (1 "M")
    (0 "@")
    (otherwise "@")))

(defun get-string-bitmap (bitmap)
  (let ((string-bitmap (make-array (get-size) :initial-element ".")))
    (dotimes (i (png-read:width *png-object*))
      (dotimes (j (png-read:height *png-object*))
        (setf (aref string-bitmap i j) (get-string (aref bitmap i j)))))
    string-bitmap))

;; 无声的保存 stirng bitmap 到文件中
(defun save-output ()
  (let ((output (get-string-bitmap (safe-png->bitmap)))
        (file "output"))
    (with-open-file (out file
                         :direction :output
                         :if-exists :supersede)
      (dotimes (i (png-read:width *png-object*))
        (dotimes (j (png-read:height *png-object*))
          (format out "~A" (aref output i j)))
        (format out "~%")))))

(defun magic-pic-png (file)
  (set-png-object file)
  (check-object-and-do-funcation #'save-output))
;;todo 解决输出时斜着的问题
(defun ratate-mirror (bitmap)
  (let ((outmap (make-array (reverse (get-size)) :initial-element 0)))
    (dotimes (i (png-read:width *png-object*))
      (dotimes (j (png-read:height *png-object*))
        (setf (aref outmap
                    ;(- (png-read:height *png-object*) (+ j 1))
                    j
                    i
                    ;(- (png-read:width  *png-object*) (+ i 1))
                    )
              (aref bitmap i j))))
    outmap))

;;修复后的保存方法
(defun save-output-fix (&optional (file "output-fix"))
  (let ((output (ratate-mirror (get-string-bitmap (safe-png->bitmap)))))
    (with-open-file (out file
                         :direction :output
                         :if-exists :supersede)
      (dotimes (i (png-read:height *png-object*))
        (dotimes (j (png-read:width *png-object*))
          (format out "~A" (aref output i j)))
        (format out "~%")))))
;; 修复后的入口方法
(defun magic-pic-png-fix (file)
  (set-png-object file)
  (check-object-and-do-funcation #'save-output-fix))
