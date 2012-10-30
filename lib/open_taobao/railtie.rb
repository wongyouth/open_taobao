require 'rails'

module OpenTaobao
  class Railtie < Rails::Railtie
    generators do
      require 'generators/open_taobao/install_generator'
    end

    initializer 'load taobao.yml' do
      config_file = Rails.root + 'config/taobao.yml'
      OpenTaobao.load(config_file) if config_file.file?
    end
  end
end
