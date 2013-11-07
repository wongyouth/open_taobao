OpenTaobao [![Build Status](https://secure.travis-ci.org/wongyouth/open_taobao.png?branch=master)](https://travis-ci.org/wongyouth/open_taobao) [![Code Climate](https://codeclimate.com/github/wongyouth/open_taobao.png)](https://codeclimate.com/github/wongyouth/open_taobao)
==========

Taobao Open Platform client for ruby. Rails3+ is supported.

## NOTICE

* `pid` is removed from config file, it's not required any more.
* Change OpenTaobao::Error message to json string from v0.2.1.

## Installation

Add this line to your application's Gemfile:

    gem 'open_taobao'

If you want to use [patron][] as http client instead of Net::HTTP, add line below to your Gemfile

    gem 'patron'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open_taobao

## Usage

### Rails with yaml file configured

Run generator to generate config file:

    $ rails g open_taobao:install

It will generate a `taobao.yml` file under your Rails' config dir.
Open the file and configure it with your taobao info.

Notice: `app_key`, `secret_key`, `endpoint` must be included in your YAML file, otherwise OpenTaobao.load will fail.

The `app_key` and `secret_key` are avaliable by `ENV['TAOBAO_API_KEY']`, `ENV['TAOBAO_SECRET_KEY']` out of the box if you use same keys for other taobao related gems, e.g. omniauth-taobao.

call `OpenTaobao.get` or `OpenTaoboa.post`，with taobao parameters：

    hash = OpenTaobao.get(
      :method => "taobao.itemcats.get",
      :fields => "cid,parent_id,name,is_parent",
      :parent_cid => 0
    )

The return data will be converted to a Hash automatically.

Also `OpenTaobao.get!` and `OpenTaobao.post!` are avaliable, which will raise an `OpenTaobao::Error` if a `error_response` receieved.

### plain ruby

    OpenTaobao.config = {
      'app_key'    => 'test',
      'secret_key' => 'test',
      'endpoint'   => "http://gw.api.tbsandbox.com/router/rest"
    }

    OpenTaobao.initialize_session

    hash = OpenTaobao.get(
      :method => "taobao.itemcats.get",
      :fields => "cid,parent_id,name,is_parent",
      :parent_cid => 0
    )

### get query string

If you want the query string with some params just pass the params to OpenTaobao.url() the same as OpenTaobao.get().
The query string will change every time your executed because timestamps changed.

    OpenTaobao.url(
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
