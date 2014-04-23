Pod::Spec.new do |s|
  s.name = 'CCARadialGradientLayer'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'CALayer subclass to draw and animate radial gradients, with the same interface as CAGradientLayer.'
  s.homepage = 'https://github.com/jilouc/CCARadialGradientLayer'
  s.authors = { 'Jean-Luc Dagon' => 'jldagon@cocoapps.fr'}
  s.source = { :git => 'https://github.com/jilouc/CCARadialGradientLayer.git', :tag => '1.0' }
  s.source_files = 'CCARadialGradientLayer/*.{h,m}'

  s.requires_arc = true
  s.ios.deployment_target = '6.0'
  s.ios.frameworks = 'QuartzCore'

end
