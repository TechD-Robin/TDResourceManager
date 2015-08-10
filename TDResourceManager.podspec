
Pod::Spec.new do |s|

  s.name         = "TDResourceManager"
  s.version      = "0.0.3"
  s.summary      = "A Resource Manager of Tech.D."

  s.homepage     = "https://git.techd.idv.tw:5001"
  s.source       = { :git => "git://git.techd.idv.tw/Libraries/TDResourceManager.git", :tag => "#{s.version}" }

  s.license      = { :type=> "No License", :file => "LICENSE" }
  s.author       = { "Robin Hsu" => "robinhsu599+dev@gmail.com" }


  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.frameworks   = 'Foundation'

  s.source_files = 'ARCMacros.h', 'TDResourceManager/*.{h,m,mm}'

  s.dependency    "Foundation+TechD",     "~> 0.0.3"
  s.dependency    "TDFoundation",         "~> 0.0.4"
  s.dependency    "fork_ZipArchive",      "~> 1.3.2"


end
