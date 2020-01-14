Pod::Spec.new do |spec|
  spec.name         = "NutPoolOC"
  spec.version      = "1.0"
  spec.summary      = "商品池。抽象了生产-消费模型"
  spec.description  = <<-DESC
  NutPool OC Version
                   DESC
  spec.platform     = :ios, "9.0"
  spec.homepage     = "https://github.com/wishWinds/NutPoolOC.git"
  spec.license      = "MIT"
  spec.author             = { "shupeng" => "john.hi.gm@gmail.com" }
  spec.source       = { :git => "https://github.com/wishWinds/NutPoolOC.git", :tag => "#{spec.version}" }
  spec.source_files  = "NutPool/**/*.{h,m}"
end
