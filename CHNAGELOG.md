## 2013-08-25 - v0.2.0 released.

* Besides HTTP `get`, `post` is supported.
* `get!`, `post!` added, these methods will raise OpenTaobao::Error when get an `error_response`.
* Remove `json` dependency in favor of `multi_json`.
* Remove `active_support` dependency, add a ActiveSupport compatible Hash hack to converted to http parameters

## 2013-05-12

pid is not required in config file, but will be loaded to config for back compatibility.
