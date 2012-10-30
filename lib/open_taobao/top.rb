require 'active_support/core_ext'
require 'digest'
require 'yaml'
require 'crack'
require 'patron'
require 'open_taobao/version'

module TOP
  REQUEST_TIMEOUT = 10
  API_VERSION = '2.0'
  USER_AGENT = "open_taobao-v#{VERSION}"

  class << self
    attr_accessor :config, :session

    def load(config_file)
      @config = YAML.load_file(config_file)
      @config = config[Rails.env] if defined? Rails
      apply_settings
    end

    def apply_settings
      ENV['TAOBAO_API_KEY']    = config['app_key']
      ENV['TAOBAO_SECRET_KEY'] = config['secret_key']
      ENV['TAOBAO_ENDPOINT']   = config['endpoint']
      ENV['TAOBAOKE_PID']      = config['pid']

      initialize_session
    end

    def initialize_session
      @session = Patron::Session.new
      #@session.base_url = config['endpoint']
      @session.headers['User-Agent'] = USER_AGENT
      @session.timeout = REQUEST_TIMEOUT
    end

    def sign(params)
      Digest::MD5::hexdigest("#{config['secret_key']}#{sorted_option_string params}#{config['secret_key']}").upcase
    end

    def sorted_option_string(options)
      options.map {|k, v| "#{k}#{v}" }.sort.join
    end

    def full_options(params)
      {
        :timestamp   => Time.now.strftime("%F %T"),
        :v           => API_VERSION,
        :format      => :json,
        :sign_method => :md5,
        :app_key     => config['app_key']
      }.merge params
    end

    def query_string(params)
      params = full_options params
      params[:sign] = sign params
      params.to_query
    end

    def url(params)
      "%s?%s" % [config['endpoint'], query_string(params)]
    end

    def parse_result(data)
      Crack::JSON.parse(data)
    end

    def get(params)
      path = url(params)
      parse_result session.get(path).body
    end
  end
end

