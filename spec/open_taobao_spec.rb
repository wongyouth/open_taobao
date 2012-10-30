# encoding: utf-8
require 'spec_helper'
require 'tempfile'

describe OpenTaobao do
 ENDPOINT = "http://gw.api.tbsandbox.com/router/rest"

  before(:each) do
    @now = Time.parse('2012-10-29 23:30')
    Time.stub(:now) { @now }
  end

  let(:config_file) do
    file = Tempfile.new 'taobao'
    File.open file.path, 'w+' do |f|
      f.write <<-EOS.gsub(/^ +/, '')
        app_key:    'test'
        secret_key: 'test'
        pid:        'test'
        endpoint:   '#{ENDPOINT}'
      EOS
    end
    file
  end

  # we only need to load config file here once for all test
  it "should load config file" do
    OpenTaobao.load(config_file.path)
    OpenTaobao.config.should == {
      'app_key'    => 'test',
      'secret_key' => 'test',
      'pid'        => 'test',
      'endpoint'   => "http://gw.api.tbsandbox.com/router/rest"
    }
  end

  it "should merge with default options" do
    options = {:foo => 'foo', :bar => 'bar'}
    OpenTaobao.full_options(options).should ==
    {
      :foo         => 'foo',
      :bar         => 'bar',
      :timestamp   => @now.strftime("%F %T"),
      :v           => '2.0',
      :format      => :json,
      :sign_method => :md5,
      :app_key     => 'test'
    }
  end

  # ref: http://open.taobao.com/doc/detail.htm?spm=0.0.0.30.iamImZ&id=111
  it "should return sorted options string" do
    options = {
      'timestamp'  => '2011-07-01 13:52:03',
      'v'          => '2.0',
      'app_key'    => 'test',
      'method'     => 'taobao.user.get',
      'sign_method'     => 'md5',
      'format'     => 'xml',
      'nick'       => '商家测试帐号17',
      'fields'     => 'nick,location.state,location.city'
    }
    OpenTaobao.sorted_option_string(options).should == "app_keytestfieldsnick,location.state,location.cityformatxmlmethodtaobao.user.getnick商家测试帐号17sign_methodmd5timestamp2011-07-01 13:52:03v2.0"
  end

  # ref: http://open.taobao.com/doc/detail.htm?spm=0.0.0.30.iamImZ&id=111
  it "should return signature" do
    options = {
      'timestamp'  => '2011-07-01 13:52:03',
      'v'          => '2.0',
      'app_key'    => 'test',
      'method'     => 'taobao.user.get',
      'sign_method'     => 'md5',
      'format'     => 'xml',
      'nick'       => '商家测试帐号17',
      'fields'     => 'nick,location.state,location.city'
    }
    OpenTaobao.sign(options).should == '5029C3055D51555112B60B33000122D5'
  end

  it "should return query string for url" do
    options = {
      :timestamp  => '2011-07-01 13:52:03',
      :method     => 'taobao.user.get',
      :format     => 'xml',
      :partner_id => 'top-apitools',
      'nick'       => '商家测试帐号17',
      'fields'     => 'nick,location.state,location.city'
    }
    OpenTaobao.query_string(options).should include("sign=")
    OpenTaobao.query_string(options).should include("timestamp=")
    OpenTaobao.query_string(options).should include("method=taobao.user.get")
    OpenTaobao.query_string(options).should include("format=xml")
    OpenTaobao.query_string(options).should include("partner_id=top-apitools")
  end

  it "should return url with endpoint" do
    options = {
      :timestamp  => '2011-07-01 13:52:03',
      :method     => 'taobao.user.get',
      :format     => 'xml',
      :partner_id => 'top-apitools',
      'nick'      => '商家测试帐号17',
      'fields'    => 'nick,location.state,location.city'
    }
    OpenTaobao.url(options).should start_with(ENDPOINT)
  end

  it "should parse result data" do
    data = '
      "item_get_response": {
          "item": {
            "item_imgs": {
              "item_img": [
              ]
            }
          }
      }
    '

    OpenTaobao.parse_result(data).should == {
      "item_get_response" => {
        'item' => {
          "item_imgs" => { "item_img" => []}
        }
      }
    }
  end

  it "should support get method" do
    OpenTaobao.initialize_session
    params = {
      :method => "taobao.itemcats.get",
      :fields => "cid,parent_id,name,is_parent",
      :parent_cid => 0
    }

    OpenTaobao.get(params)['itemcats_get_response']['item_cats']['item_cat'].should be_a(Array)
  end
end

# OpenTaobao.load(File.expand_path('../taobao.yml',__FILE__))
# 
# def pretty(json)
#   puts JSON.pretty_generate(json)
# end
# 
# params = {
#   :method => "taobao.itemcats.get",
#   :fields => "cid,parent_id,name,is_parent",
#   :parent_cid => 0
# }
# 
# pretty(OpenTaobao.get(params))
# 
# params = {
#   :method => "taobao.taobaoke.items.get",
#   :fields => "num_iid,title,nick,pic_url,price,click_url, commission,commission_num,volume",
#   :cid => 30, # 男装
#   :pid => OpenTaobao::PID
# }
# 
# pretty(OpenTaobao.get(params))
# 
# params = {
#   :method => "taobao.item.get",
#   :fields => "prop_img.url,item_img.url,nick",
#   :num_iid => 19276752117
# }
# 
# pretty(OpenTaobao.get(params))
# 
