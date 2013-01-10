OpenTaobao [![Build Status](https://secure.travis-ci.org/wongyouth/open_taobao.png?branch=master)](https://travis-ci.org/wongyouth/open_taobao)
==========

Taobao Open Platform client for ruby. Rails3 is supported.

## Installation

Add this line to your application's Gemfile:

    gem 'open_taobao'

If you want to use [patron][] as http client instead of Net::HTTP, add line below to your Gemfile

    gem 'patron'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open_taobao

Run generate to complete install:

    $ rails g open_taobao:install

It will generate a `taobao.yml` file under your Rails' config dir.
Open the file and configure it with your taobao info.

`app_key`, `secret_key`, `pid`, `endpoint` must be configured in your YAML file, otherwise OpenTaobao.load will fail.

## Usage

### Rails with yaml file configured

call `OpenTaobao.get`，with taobao parameters：

    hash = OpenTaobao.get(
      :method => "taobao.itemcats.get",
      :fields => "cid,parent_id,name,is_parent",
      :parent_cid => 0
    )

The return data will be converted to Hash automatically.

### plain ruby

    OpenTaobao.config = {
      'app_key'    => 'test',
      'secret_key' => 'test',
      'pid'        => 'test',
      'endpoint'   => "http://gw.api.tbsandbox.com/router/rest"
    }

    OpenTaobao.initialize_session

    hash = OpenTaobao.get(
      :method => "taobao.itemcats.get",
      :fields => "cid,parent_id,name,is_parent",
      :parent_cid => 0
    )

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[patron]: https://github.com/toland/patron
