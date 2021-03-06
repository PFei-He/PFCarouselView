[PFCarouselView](https://github.com/PFei-He/PFCarouselView)
===

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg)](https://raw.githubusercontent.com/PFei-He/PFCarouselView/master/LICENSE)
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/PFCarouselView.svg)](https://img.shields.io/cocoapods/v/PFCarouselView.svg)
 
[中文介绍](https://github.com/PFei-He/PFCarouselView/blob/master/README-CN.md)

PFCarouselView is easy to create a carousel view for news app.
 
PFCarouselView is still in development, welcome to improve the project together.

Version
---
0.8.0

Installation with CocoaPods
---
```
source 'https://github.com/CocoaPods/Specs.git'
platform:ios, '6.0'
 
target 'YourTarget' do
    pod 'PFCarouselView', '~> 0.8'
end
```

Code list
---
```objective-c
//create carousel view
PFCarouselView *carouselView = [[PFCarouselView alloc] initWithFrame:CGRectMake(0, 100, 320, 200)];
```

```objective-c
//setup pages
[carouselView numberOfPagesUsingBlock:^NSInteger {
    return viewsArray.count;
}];
```

```objective-c
//setup content view
[carouselView setupContentViewUsingBlock:^UIView *(NSInteger index) {
    return viewsArray[index];
}];
```

Show results
---
![image](https://github.com/PFei-He/PFCarouselView/blob/master/PFCarouselView.gif)

License
---
`PFCarouselView` is released under the MIT license, see [LICENSE](https://raw.githubusercontent.com/PFei-He/PFCarouselView/master/LICENSE) for details.
