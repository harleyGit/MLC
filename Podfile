source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'MLC' do
  # use_frameworks!
  pod 'JSONModel', '1.8.0'
  pod 'MBProgressHUD', '1.0.0'
  pod 'Masonry', '1.1.0'
  pod 'WechatOpenSDK', '1.8.2'
  pod 'MJRefresh', '3.1.15.7'
  pod 'ReactiveObjC', '3.1.1'
  pod 'AFNetworking', '4.0.1'
  pod 'MJExtension', '3.0.15.1'
  pod 'ZFPlayer', '3.2.13'
  pod 'SDWebImage', '5.7.3'
  #路由导航：http://github.com/mogujie/MGJRouter
  pod 'MGJRouter', '0.10.0'
  
  #Swift
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'RxGesture', '3.0.2'
  pod 'SnapKit', '5.0.1'
  pod 'Alamofire', '5.0'
  pod 'SwiftyJSON', '5.0.0' # Source: https://github.com/SwiftyJSON/SwiftyJSON.git
  pod 'ObjectMapper', '3.5.1'
  pod 'HandyJSON', '5.0.0'# Source:   Source: https://github.com/alibaba/HandyJSON.git
  #网络请求库：https://github.com/Moya/Moya
  pod 'Moya', '15.0.0-alpha.1'
  
  
  #融云SDK
  #pod 'RongCloudIM/IMLib', '~>2.9.6'  #IM 界面组件
  #pod 'RongCloudIM/IMKit', '~>2.9.6'  #IM 通讯能力库
  #Pods for HGSWB
  
  target 'MLCTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'MLCUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
        end
      end
    end
  end
  
  
  
end
