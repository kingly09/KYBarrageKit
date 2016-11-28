Pod::Spec.new do |s|
s.name         = "KYBarrageKit"
s.summary      = "KYBarrageKit this is a high availability, easy to use barrage Framework Library."
s.version      = '0.0.4'
s.homepage     = "https://github.com/kingly09/KYBarrageKit"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "kingly" => "libintm@163.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/kingly09/KYBarrageKit.git", :tag => s.version.to_s }
s.social_media_url   = "https://github.com/kingly09"
s.source_files = 'KYBarrageKit/*.{h,m}'
s.framework    = "UIKit"
s.requires_arc = true
end
