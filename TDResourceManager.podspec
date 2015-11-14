
Pod::Spec.new do |s|

  s.name         = "TDResourceManager"
  s.version      = "0.0.3"
  s.summary      = "The `TDResourceManager` is base resource manager library of Tech.D."

  s.description  = <<-DESC
                   The `TDResourceManager` is base resource manager library of Tech.D.

                   * The Resource Manager provide the same method to get resources,
                   *  can get resources from resourcePath(normal file system), assets bundle object and zipped file.
                   DESC

  s.homepage     = "https://github.com/TechD-Robin/TDResourceManager/"
  s.source       = { :git => "https://github.com/TechD-Robin/TDResourceManager.git", :tag => "#{s.version}" }

  s.license            = 'MIT'
  s.author             = { "Robin Hsu" => "robinhsu599+dev@gmail.com" }
  s.social_media_url   = "https://plus.google.com/+RobinHsu"


  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.frameworks   = 'Foundation'

  s.source_files = 'ARCMacros.h', 'TDResourceManager/*.{h,m,mm}'

  s.dependency    "TDforkZipArchive",     "~> 1.3.2"
  s.dependency    "TDFoundation",         "~> 0.0.4"
  #s.dependency    "Foundation+TechD",     "~> 0.0.3"


end
