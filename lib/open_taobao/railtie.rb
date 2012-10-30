require 'rails'

module TOP
  class Railtie < Rails::Railtie
    generators do
      require 'generators/install_generator'
    end

    initializer 'load taobao.yml' do
      TOP.load(Rails.root + 'config/taobao.yml')
    end
  end
end
