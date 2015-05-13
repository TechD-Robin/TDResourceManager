
Pod::Spec.new do |s|

  s.name         = "TDResourceManager"
  s.version      = "0.0.1"
  s.summary      = "A Resource Manager of Tech.D."

  s.homepage     = "https://git.techd.idv.tw:5001"
  s.source       = { :git => "git://git.techd.idv.tw/Libraries/TDResourceManager.git", :tag => "#{s.version}" }

  s.license      = { :type=> "No License", :file => "LICENSE" }
  s.author       = { "Robin Hsu" => "robinhsu599+dev@gmail.com" }


  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.frameworks   = 'Foundation'

  s.source_files = 'ARCMacros.h', 'TDResourceManager/*.{h,m,mm}'


  #s.dependency    "AFNetworking",         "~> 2.5.2"
  #s.dependency    "TDFoundation",         "~> 0.0.2"
  #s.dependency    "Foundation+TechD",     "~> 0.0.1"

  s.dependency    "Foundation+TechD",      "~> 0.1"
  s.dependency    "TDFoundation",          "~> 0.1" 
  s.dependency     "ZipArchive",           "~> 1.3.2"


end
