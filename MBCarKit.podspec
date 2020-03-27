Pod::Spec.new do |s|
  s.name          = "MBCarKit"
  s.version       = "2.0.0"
  s.summary       = "MBCarKit is a public Pod of MBition GmbH"
  s.description   = "The main part of this module is CarKit, it is the facade to communicate with all provided services. It contains a socketService which can create a socket connection to get live data of the vehicle or send command requests to it. The data of the vehicle gets automatically cached."
  s.homepage      = "https://mbition.io"
  s.license       = 'MIT'
  s.author        = { "MBition GmbH" => "info_mbition@daimler.com" }
  s.source        = { :git => "https://github.com/Daimler/MBSDK-CarKit-iOS.git", :tag => String(s.version) }
  s.platform      = :ios, '10.0'
  s.swift_version = ['5.0', '5.1', '5.2']

  s.source_files = 'MBCarKit/MBCarKit/**/*.{swift,xib}'

  # dependencies to MBRSCommon
  s.dependency 'MBCommonKit', '~> 2.0'
  s.dependency 'MBNetworkKit/Basic', '~> 2.0'
  s.dependency 'MBNetworkKit/Socket', '~> 2.0'
  s.dependency 'MBRealmKit/Layer', '~> 2.0'

  # public dependencies
  s.dependency 'SwiftProtobuf', '~> 1.0'
  s.dependency 'ZIPFoundation', '~> 0.9'
end
