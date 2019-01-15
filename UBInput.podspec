

Pod::Spec.new do |s|

  s.name         = "UBInput"
  s.version      = "0.0.1"
  s.summary      = "UBInput 提供输入框的逻辑（无UI），可实现类似微信下面的输入"
  s.description  = <<-DESC
	            UBInput 提供输入框的逻辑（无UI），可实现类似微信下面的输入...
                   DESC

  s.homepage     = "https://github.com/Crazysiri/UBInput.git"

   s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "zero" => "511121933@qq.com" }

  s.source       = { :git => "https://github.com/Crazysiri/UBInput.git", :tag => "#{s.version}" }

   s.platform     = :ios, "9.0"


  s.source_files  = "UBInput/*.{h,m}"


end
