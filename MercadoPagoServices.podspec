Pod::Spec.new do |s|
  s.name             = "MercadoPagoServices"
  s.version          = "1.0.6"
  s.summary          = "MercadoPago Services"
  s.homepage         = "https://www.mercadopago.com"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = "Mercado Pago"
  s.source           = { :git => "https://github.com/mercadopago/px-ios_services", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source_files = ['MercadoPagoServices/*']
  s.dependency 'MercadoPagoPXTracking', '2.1.0'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
