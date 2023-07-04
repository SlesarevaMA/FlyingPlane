# Uncomment the next line to define a global platform for your project
 platform :ios, '16.0'

target 'FlyingPlane' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  
  pod 'FirebaseCrashlytics'
  pod 'FirebaseAnalytics'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  
end

# Символы в дебаге
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
    end
  end
end
