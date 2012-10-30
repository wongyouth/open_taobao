# -*- encoding: utf-8 -*-
require File.expand_path('../lib/open_taobao/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["wongyouth"]
  gem.email         = ["wongyouth@gmail.com"]
  gem.description   = %q{淘宝开放平台ruby版，支持Rails3}
  gem.summary       = %q{Open Taobao API for ruby}
  gem.homepage      = "http://github.com/wongyouth/open_taobao"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "open_taobao"
  gem.require_paths = ["lib"]
  gem.version       = OpenTaobao::VERSION

  gem.add_dependency "crack"
  gem.add_dependency "patron"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "autotest"
end
