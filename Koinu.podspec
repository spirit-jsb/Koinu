Pod::Spec.new do |s|
    
    s.name = 'Koinu'
    s.version = '1.0.0'

    s.summary = 'Koinu 是一个自定义 UINavigationController 框架。'
    s.description = <<-DESC
                    Koinu 是一个自定义 UINavigationController 框架，通过对 UIViewController 进行包装，使每个 UIViewController 独立的维护各自的 UINavigationBar 的样式，
                    从而避免了在 UIViewController 的 viewWillAppear(_:) 与 viewDidDisappear(_:) 方法中修改 UINavigationBar 样式所导致的问题
                    DESC

    s.authors = { 'spirit-jsb' => 'sibo_jian_29903549@163.com' }
    s.license = 'MIT'
    
    s.homepage = 'https://github.com/spirit-jsb/Koinu.git'

    s.ios.deployment_target = '10.0'

    s.swift_versions = ['5.0']

    s.frameworks = 'Foundation', 'UIKit'

    s.source = { :git => 'https://github.com/spirit-jsb/Koinu.git', :tag => s.version }

    s.default_subspecs = 'Core'
    
    s.subspec 'Core' do |sp|
        sp.source_files = ['Sources/Core/**/*.swift', 'Sources/Extensions/**/*.swift', 'Sources/Koinu.h']
    end

end