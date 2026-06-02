source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'   # ← Убедитесь, что здесь 13.0

# Добавьте эти строки для подавления предупреждений
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

target 'Navigation' do
  use_frameworks!
  
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
end