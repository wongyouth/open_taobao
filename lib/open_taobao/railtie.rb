require 'rails'

module TOP
  class Railtie < Rails::Railtie
    generators do
      require 'generators/top/install_generator'
    end

    initializer 'load taobao.yml' do
      config_file = Rails.root + 'config/taobao.yml'
      TOP.load(config_file) if config_file.file?
    end
  end
end
