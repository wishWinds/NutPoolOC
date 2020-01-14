Pod::Spec.new do |spec|
  spec.name         = "NutPoolOC"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of NutPoolOC."
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
