[PFCarouselView](https://github.com/PFei-He/PFCarouselView)
===

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg)](https://raw.githubusercontent.com/PFei-He/PFCarouselView/master/LICENSE)
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/PFCarouselView.svg)](https://img.shields.io/cocoapods/v/PFCarouselView.svg)

PFCarouselView 是一款简单接入便可实现新闻客户端轮播图的开源库。<br>
PFCarouselView is easy to create a carousel view for news app.

版本 Version
---
0.7.0

CocoaPods
---
```
platform:ios, '6.0'
pod 'PFCarouselView', '~> 0.7'
```

代码展示 Code list
---
```
//创建一个轮播图 create carousel view
carouselView = [[PFCarouselView alloc] initWithFrame:CGRectMake(0, 100, 320, 200) animationDuration:2 delegate:nil];
```

```
//设置页数 setup pages
[carouselView numberOfPagesInCarouselViewUsingBlock:^NSInteger(PFCarouselView *carouselView){
    return viewsArray.count;
}];
```

```
//设置视图 setup content view
[carouselView contentViewAtIndexUsingBlock:^UIView *(PFCarouselView *carouselView, NSInteger index) {
    return viewsArray[index];
}];
```

运行效果展示 Show results
---
![image](https://github.com/PFei-He/PFCarouselView/blob/master/PFCarouselView.gif)

许可证 License
---
`PFCarouselView`使用 MIT 许可证，详情见 [LICENSE](https://raw.githubusercontent.com/PFei-He/PFCarouselView/master/LICENSE) 文件。<br>
`PFCarouselView` is released under the MIT license, see [LICENSE](https://raw.githubusercontent.com/PFei-He/PFCarouselView/master/LICENSE) for details.