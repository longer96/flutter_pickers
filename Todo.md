

### flutter packages pub publish --dry-run

- 上传的时候取消国内镜像
- flutter packages pub publish -v 
- 验证是否可以访问外网 curl google.com

### 打开代理之后，命令行设置外网代理
'''
export https_proxy=http://127.0.0.1:1087
export http_proxy=http://127.0.0.1:1087
set https_proxy=https://127.0.0.1:1087
set http_proxy=http://127.0.0.1:1087
'''





## 颜色选择器



## 时间选择器文档
- 支持数据混传  num string
- 多语言可参考 flutter_picker
- [DateMode.MDHMS, DateMode.MDHM, DateMode.MDH, DateMode.MD]



## 时间 
### 样式模板
- 模板1
- 模板2 
- 自定义模板
- light dark

## 参数 
<< 以下可以选择2种参数 DateTime  或则自己定的参数
- maxDate
- minDate
- initDate

### 自动适配时间格式


- 年月日时分秒的单位 {year:1990, hours: 12}
- 初始化 时间  进去默认选择
- 设置时间区间？ 

``` dart
  initialDate: type == 1 ? start_time : end_time,
  firstDate: DateTime(2020),
  lastDate: DateTime(2100),
```






