[PFCarouselView](https://github.com/PFei-He/PFCarouselView)
===

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg)](https://raw.githubusercontent.com/PFei-He/PFCarouselView/master/LICENSE)
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/PFCarouselView.svg)](https://img.shields.io/cocoapods/v/PFCarouselView.svg)

PFCarouselView 是一款简单接入便可实现新闻客户端轮播图的开源库。

项目仍在开发中，欢迎一起完善这个项目。

版本
---
0.8.0

使用CocoaPods
---
```
source 'https://github.com/CocoaPods/Specs.git'
platform:ios, '6.0'

target 'YourTarget' do
    pod 'PFCarouselView', '~> 0.8'
end
```

代码展示
---
```objective-c
//创建一个轮播图
PFCarouselView *carouselView = [[PFCarouselView alloc] initWithFrame:CGRectMake(0, 100, 320, 200)];
```

```objective-c
//设置页数
[carouselView numberOfPagesUsingBlock:^NSInteger{
    return viewsArray.count;
}];
```

```objective-c
//设置视图
[carouselView setupContentViewUsingBlock:^UIView *(NSInteger index) {
    return viewsArray[index];
}];
```

运行效果展示
---
![image](https://github.com/PFei-He/PFCarouselView/blob/master/PFCarouselView.gif)

许可证
---
`PFCarouselView`使用 MIT 许可证，详情见 [LICENSE](https://raw.githubusercontent.com/PFei-He/PFCarouselView/master/LICENSE) 文件。
