platform :ios, '13.0'

target 'Navigation' do
  use_frameworks!
  
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
      config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = 'YES'
    end
  end
end