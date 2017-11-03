Pod::Spec.new do |s|

  s.name         = "SwiftChartView"
  s.version      = "0.2.0"
  s.summary      = "A set of chart views written in Swift."

  s.description  = <<-DESC
                    A set of chart views written in Swift. It's simple and elegant.
                   DESC

  s.homepage         = 'https://github.com/derekcoder/SwiftChartView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'derekcoder' => 'derekcoder@gmail.com' }
  s.source           = { :git => 'https://github.com/derekcoder/SwiftChartView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = ['SwiftChartView/Sources/*.swift', 'SwiftChartView/SwiftChartView.h']
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
