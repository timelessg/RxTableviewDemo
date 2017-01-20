platform :ios, '8.0'
use_frameworks!

target 'RxTableviewDemo' do
pod 'Alamofire'
pod 'RxSwift'
pod 'ObjectMapper'
pod 'RxCocoa'
pod 'RxDataSources'
pod 'SnapKit'
pod 'RxDataSources'
pod 'PullToRefreshSwift'
end

post_install do |installer| 
installer.pods_project.targets.each do |target| 
target.build_configurations.each do |config| 
config.build_settings['SWIFT_VERSION'] = '3.0'
end
end
end
