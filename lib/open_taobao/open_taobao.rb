#--
# Copyright (c) 2012 Wang Yongzhi
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

module OpenTaobao
  REQUEST_TIMEOUT = 10
  API_VERSION = '2.0'
  USER_AGENT = "open_taobao-v#{VERSION}"

  class << self
    attr_accessor :config, :session

    # Load a yml config, and initialize http session
    # yml config file content should be:
    #
    #   app_key:    "YOUR APP KEY"
    #   secret_key: "YOUR SECRET KEY"
    #   pid:        "YOUR TAOBAOKE pid"
    #   endpoint:   "TAOBAO GATEWAY API URL"
    #
    def load(config_file)
      @config = YAML.load_file(config_file)
      @config = config[Rails.env] if defined? Rails
      check_config_and_export_to_env
      initialize_session
    end

    # check config and export all setting to ENV
    def check_config_and_export_to_env
      check_config
      export_config_to_env
    end

    # check config
    #
    # raise exception if config key missed in YAML file
    def check_config
      list = []
      %w(app_key secret_key pid endpoint).map do |k|
        list << k unless config.has_key? k
      end

      raise "[#{list.join(', ')}] not included in your yaml file." unless list.empty?
    end

    # setting ENV variables from config
    #
    # ENV variables:
    # 
    #   TAOBAO_API_KEY    -> config['app_key']
    #   TAOBAO_SECRET_KEY -> config['secret_key']
    #   TAOBAO_ENDPOINT   -> config['endpoint']
    #   TAOBAOKE_PID      -> config['pid']
    def export_config_to_env
      ENV['TAOBAO_API_KEY']    = config['app_key']
      ENV['TAOBAO_SECRET_KEY'] = config['secret_key']
      ENV['TAOBAO_ENDPOINT']   = config['endpoint']
      ENV['TAOBAOKE_PID']      = config['pid']
    end

    # Initialize http sesison
    def initialize_session
      @session = Faraday.new :url => config['endpoint'] do |builder|
        begin
          require 'patron'
          builder.adapter :patron
        rescue
        end
      end
    end

    # Return request signature with MD5 signature method
    def sign(params)
      Digest::MD5::hexdigest("#{config['secret_key']}#{sorted_option_string params}#{config['secret_key']}").upcase
    end

    # Return sorted request parameter by request key
    def sorted_option_string(options)
      options.map {|k, v| "#{k}#{v}" }.sort.join
    end

    # Merge custom parameters with TAOBAO system parameters.
    #
    # System paramters below will be merged. 
    #
    #   timestamp
    #   v
    #   format
    #   sign_method
    #   app_key
    #
    # Current Taobao API Version is '2.0'.
    # <tt>format</tt> should be json.
    # Only <tt>sign_method</tt> MD5 is supported so far.
    def full_options(params)
      {
        :timestamp   => Time.now.strftime("%F %T"),
        :v           => API_VERSION,
        :format      => :json,
        :sign_method => :md5,
        :app_key     => config['app_key']
      }.merge params
    end

    # Retrun query string with signature.
    def query_string(params)
      params = full_options params
      params[:sign] = sign params
      "?" + params.to_query
    end

    # Return full url with signature.
    def url(params)
      "%s%s" % [config['endpoint'], query_string(params)]
    end

    # Return a parsed JSON object.
    def parse_result(data)
      JSON.parse(data)
    end

    # Return response in JSON format
    def get(params)
      path = query_string(params)
      parse_result session.get(path).body
    end
  end
end

