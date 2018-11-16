Pod::Spec.new do |s|
  s.name         = "SYProgressView"
  s.version      = "1.0.1"
  s.summary      = "SYProgressView show the progress while change value."
  s.homepage     = "https://github.com/potato512/SYProgressView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "herman" => "zhangsy757@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/potato512/SYProgressView.git", :tag => "#{s.version}" }
  s.source_files  = "SYProgressView/*.{h,m}"
  s.requires_arc = true
end
