platform :ios,'10.0'
use_frameworks!
inhibit_all_warnings!
workspace 'MBCarKit'

def pods
  # code analyser
  pod 'SwiftLint', '~> 0.30'

  # code generator
  pod 'Sourcery', '~> 0.16'

  # data
  pod 'SwiftProtobuf', '~> 1.0'

  # module
  pod 'MBCommonKit', '~> 1.0'
  pod 'MBNetworkKit/Basic', '~> 1.0'
  pod 'MBNetworkKit/Socket', '~> 1.0'
  pod 'MBRealmKit', '~> 1.0'
end


target 'Example' do
	project 'Example/Example'
	
	pods
end

target 'MBCarKit' do
	project 'MBCarKit/MBCarKit'
	
	pods

	target 'MBCarKitTests' do
	end
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
