# fluent-plugin-http-include-time-key

[Fluentd](https://fluentd.org/) input plugin to do something.

* in_http plugin for including time tag in record in case of post multiple records. 

## Installation

### RubyGems

```
$ gem install fluent-plugin-http-include-time-key
```

## Config

```
<source>
  @id source-http
  @type http_include_time_key
  port 9880
  bind 0.0.0.0
  body_size_limit 32m
  keepalive_timeout 10s
  add_remote_addr true
  time_key fluent_time
  time_format %Y-%m-%d %H:%M:%S.%L
  keep_time_key true
</source>
```

## Usage


```
$ curl -X POST -d 'json=[{"message":"TEST","time":"2018-08-09 17:00:00"},{"message":"TEST2","time":"2018-08-09 17:10:00"}]' http://localhost:9880/tag.sample -v

```

## Copyright

* Copyright(c) 2018- TODO: Write your name
* License
  * Apache License, Version 2.0
