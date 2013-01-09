require 'active_support/core_ext/object'
require 'digest'
require 'faraday'
require 'json'
require 'open_taobao/version'
require 'yaml'

require 'open_taobao/open_taobao'

require 'open_taobao/railtie' if defined? Rails
