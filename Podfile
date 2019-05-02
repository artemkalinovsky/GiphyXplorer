
platform :ios, '12.0'

target 'GiphyXplorer' do
  
  use_frameworks!
  inhibit_all_warnings!

  pod 'SwiftyJSON'
  pod 'Gifu'
  pod 'JGProgressHUD'
  pod 'RxSwift'
  pod 'RxAlamofire'
  pod 'RxRealm'
  pod 'RxDataSources'

  target 'GiphyXplorerTests' do
    inherit! :search_paths
    
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
