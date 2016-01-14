Pod::Spec.new do |s|
  s.name         = "PFCarouselView"
  s.version      = "0.7.0"
  s.summary      = "Easy to create a carousel view for news app."
  s.homepage     = "https://github.com/PFei-He/PFCarouselView"
  s.license      = "MIT"
  s.author       = { "PFei-He" => "498130877@qq.com" }
  s.platform     = :ios, "6.0"
  s.ios.deployment_target = "6.0"
  s.source       = { :git => "https://github.com/PFei-He/PFCarouselView.git", :tag => s.version }
  s.source_files  = "PFCarouselView/*"
  s.frameworks = "Foundation", "CoreGraphics", "UIKit"
  s.requires_arc = true
end
