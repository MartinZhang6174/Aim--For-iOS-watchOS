# Uncomment the next line to define a global platform for your project
# platform :ios, ’10.0’

target 'Aim!' do
  use_frameworks!

  # Pods for Aim!
pod ‘Firebase/Database’
pod ‘Firebase/Auth’
pod ‘Firebase/Storage’
pod ‘NVActivityIndicatorView’
pod ‘RealmSwift’
pod ‘BEMCheckBox’
pod ‘BFPaperButton’
pod ‘CWStatusBarNotification’
pod ‘MarqueeLabel’
pod 'FacebookCore'
pod 'FacebookLogin'

  target 'Aim! Tests' do
    inherit! :search_paths
     #Pods for testing
	pod ‘Firebase’
  end

end

target 'Aim! ' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Aim! 

  #target 'Aim! Tests' do
    #inherit! :search_paths
    # Pods for testing
  #end

end

target 'Aim! Extension' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Aim! Extension
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = ‘3.1’
    end
  end
end

