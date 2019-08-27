
Pod::Spec.new do |spec|
  spec.name         = "VVORM"
  spec.version      = "0.1.0"
  spec.summary      = "VVORM 封装FMDB数据库操作"
  spec.homepage     = "https://github.com/chinaxxren/VVORM"
  spec.license      = "MIT"
  spec.author       = { "chinaxxren" => "182421693@qq.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/chinaxxren/VVORM.git", :tag => "#{spec.version}" }
  spec.source_files  = "VVORM/Source/**/*.{h,m}"
  spec.frameworks  = "UIKit"
  spec.dependency  "FMDB"
end
