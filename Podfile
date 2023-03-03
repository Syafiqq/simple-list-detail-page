source 'https://bitbucket.org/beautyfu/ios-pod-specs.git'
source 'https://cdn.cocoapods.org/'


target 'UICollectionViewTest' do
  platform :ios, '13.0'

  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for UICollectionViewTest
  pod 'RxSwift', '= 6.7.0'
  pod 'RxBlocking', '= 6.7.0'
  pod 'RxSwiftExt', '= 6.2.2-beta.1'
  pod 'RxCocoa', '= 6.7.0'
  pod 'SkeletonView', '= 1.30.99-beta.1'
  pod 'SnapKit', '= 5.7.1'
  pod 'LanguageManager-iOS', '= 1.2.8-beta.1'
  pod 'LifetimeTracker', '= 1.8.3'
  pod 'CodableWrappers', '= 2.0.7'
  pod 'SwiftDate', '= 7.0.0'
  pod 'CRRefresh', '= 1.1.3'
  pod 'Alamofire', '= 5.9.1'
  pod 'AlamofireNetworkActivityLogger', '= 3.4.1-beta.1'
  pod 'RxAlamofire', '= 6.1.3-beta.3'
  pod 'Realm', '= 10.49.2'
  pod 'RealmSwift', '= 10.49.2'
  pod 'SwiftEventBus', '= 5.1.1-beta.1'
  pod 'SwiftLint', '= 0.54.0'
  pod 'ZMarkupParser', '= 1.8.2-beta.1'
  pod 'lottie-ios', '= 4.4.3'
  pod 'SwiftSoup', '= 2.7.2'
  pod 'XLPagerTabStrip', '= 9.1.1-beta.1'
  pod 'BottomSheet', '= 2.0.5-beta.3'
  pod 'Reveal-SDK', :configurations => ['Debug']
  pod 'Kingfisher', '7.12.0'
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
