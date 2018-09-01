Pod::Spec.new do |s|

  s.name         = "UITableViewManager"
  s.version      = "1.1"
  s.summary      = "Better way to deal with UITableView"

  s.homepage     = "https://github.com/YuriFox/UITableViewManager"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "YuriFox" => "yuri17fox@gmail.com" }
  
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/YuriFox/UITableViewManager.git", :tag => s.version.to_s }

  s.source_files = "UITableViewManager/*.swift"
  
end
