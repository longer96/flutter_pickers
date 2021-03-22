

### 检查发布是否OK
- flutter packages pub publish --dry-run

- 上传的时候取消国内镜像
- 发布命令：flutter packages pub publish -v 
- 验证是否可以访问外网 curl google.com

### 打开代理之后，命令行设置外网代理
'''
export https_proxy=http://127.0.0.1:1087
export http_proxy=http://127.0.0.1:1087
set https_proxy=https://127.0.0.1:1087
set http_proxy=http://127.0.0.1:1087
'''


windows
```
set http_proxy=127.0.0.1:1080
set https_proxy=127.0.0.1:1080
取消代理
unset http_proxy
unset https_proxy
```

### web上传到服务器
- https://github.com/MMMzq/bot_toast/blob/master/README_zh.md
- github 有提供静态web环境
- gh_pages 分支


### web
- flutter channel 列出所有版本
- flutter channel dev  切换
- flutter config --enable-web
- flutter create .   开始创建web目录文件，执行完毕后，在项目中多了个一个web目录
- flutter run -d chrome
- flutter build web 打包web


## todo 
- 颜色选择器
- 多项选择器联动问题

## 时间选择器文档
- 多语言可参考 flutter_picker




