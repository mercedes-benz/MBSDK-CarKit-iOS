
Pod::Spec.new do |s|
  s.name          = "MBCarKit"
  s.version       = "1.0.0"
  s.summary       = "MBCarKit is a public Pod of MBition GmbH"
  s.description   = "The main part of this module is CarKit, it is the facade to communicate with all provided services. It contains a socketService which can create a socket connection to get live data of the vehicle or send command requests to it. The data of the vehicle gets automatically cached."
  s.homepage      = "https://mbition.io"
  s.license       = 'MIT'
  s.author        = { "MBition GmbH" => "info_mbition@daimler.com" }
  s.source        = { :git => "https://github.com/Daimler/MBSDK-CarKit-iOS.git", :tag => String(s.version) }
  s.platform      = :ios, '10.0'
  s.requires_arc  = true
  s.swift_version = ['4.2', '5.0']

  s.source_files = 'MBCarKit/MBCarKit/**/*.{swift,xib}'

  # dependencies to MBRSCommon
  s.dependency 'MBCommonKit', '~> 1.0'
  s.dependency 'MBNetworkKit/Basic', '~> 1.0'
  s.dependency 'MBNetworkKit/Socket', '~> 1.0'
  s.dependency 'MBRealmKit/Layer', '~> 1.0'

  # public dependencies
  s.dependency 'SwiftProtobuf', '~> 1.0'

end
