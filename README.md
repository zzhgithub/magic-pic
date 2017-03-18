# Magic PIC

# 功能

    使用`common lisp`把png格式的图片变成字符串的形式

# 可用函数

    magic-pic-png
    实例：
    ``` common-lisp
    (magic-pic-png "~/test.png")
    ;;输出文件会出现在output中
    ```
    
    
# 安装方法

    请使用`quicklisp`到本地system进行安装使用。使用前使用`(ql:qiukload "magic-pic")`
    
# TODO

- 修复图片旋转90度和镜像问题
- 添加输出文件的入参
- 添加gif格式的文件解析
- 添加对文件格式的自动识别
- 优化生成算法

> [网站](http://zzhcoding.coding.me/%E6%8A%80%E6%9C%AF%E5%88%86%E4%BA%AB/2017/03/17/%E4%BD%BF%E7%94%A8Common-Lisp%E5%86%99%E4%B8%80%E4%B8%AApng-%E6%96%87%E6%9C%AC%E8%BD%AC%E6%8D%A2%E5%99%A8.html)
