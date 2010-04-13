Store objects in Redis

    sudo gem install redis-objective

Usage
=====
    require 'redis/objective'
    redis = Redis.new(:host => ...).objective

    redis['xxx'] = {:foo => :bar}
    redis['xxx'] # {:foo => :bar}
    redis['xxx'] = nil # delete key 'xxx'

    # Non-objects can be read:
    pure = Redis.new
    pure['xxx'] = 'abc'
    redis['xxx'] # 'abc'

    # get/set - many
    redis.mset('xxx' => {:foo => :bat}, 'yyy' => 'something else') # {'xxx' => {:foo => :bar}, 'yyy' => 'something else'}
    redis.mget('xxx','yyy') # {'xxx' => {:foo => :bar}, 'yyy' => 'something else'}

### Supported methods

 - get / []
 - set /set_with_expire / []=
 - mget / mapped_mget
 - mset / mapped_mset
 - all other missing methods are delegated

TODO
====
 - also unset keys that were set to nil via mset

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...