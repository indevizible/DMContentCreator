Pod::Spec.new do |s|
  s.name     = 'DMContentCreator'
  s.version  = '0.0.4'
  s.license  = 'Beerware' 
  s.summary  = 'Content creator plugin for DMConnex plugin'
  s.homepage = 'http://www.infostant.com/'
  s.author   = { 'Nattawut Singhchai' => 'wut@2bsimple.com' }

  s.source   = { :git => 'https://github.com/indevizible/DMContentCreator.git',:tag => '0.0.4'}

  s.platform = :ios

  s.source_files = 'DMContentCreator/Classes/*.{h,m}','DMContentCreator/Classes/**/*.{h,m}'

  s.resources = 'DMContentCreator/Resources/*.{storyboard,png,bundle}'
  #s.exclude_files = 'Graphics/Default-568h@2x.png'
  s.requires_arc = true
  #s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics', 'QuartzCore', 'ImageIO', 'MessageUI'
    s.dependency 'UIImage-Resize'
    s.dependency 'SIAlertView'
    s.dependency 'LAUtilitiesStaticLib'
    s.dependency 'BlocksKit'
    s.dependency 'ALActionBlocks'
    s.dependency 'WTGlyphFontSet'
    s.dependency 'WTGlyphFontSet/social_foundicons'
    s.dependency 'WTGlyphFontSet/entypo'
    s.dependency 'WTGlyphFontSet/entypo-social'
    s.dependency 'WTGlyphFontSet/fontawesome'
    s.dependency 'WTGlyphFontSet/general_foundicons'
    s.dependency 'HCYoutubeParser'
    s.dependency 'IDMPhotoBrowser'
    s.dependency 'FoundationExtension'
    s.dependency 'RNGridMenu'
    s.dependency 'MBProgressHUD'
    s.dependency 'EGYWebViewController'
    s.dependency 'iOS7Colors'
    s.dependency 'CZPhotoPickerController'
    s.dependency 'BSModalPickerView'
    s.dependency 'BVReorderTableView'
    s.dependency 'SWTableViewCell'
end
