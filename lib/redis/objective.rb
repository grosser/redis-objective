require 'redis'

class Redis::Client
  def objective
    @@objective ||= Redis::Objective.new(self)
  end
end

class Redis::Objective
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','..','VERSION') ).strip

  def initialize(client)
    @client = client
  end

  def get(key, *args)
    value = @client.get(key, *args)
    return if value.nil?
    YAML.load(value)
  end
  alias :[] :get

  def set(key, value, *args)
    if value.nil?
      @client.del(key)
    else
      if args.empty?
        @client.set(key, value.to_yaml)
      else
        @client.set_with_expire(key, value.to_yaml, *args)
      end
    end
    value
  end
  alias :[]= :set
  alias :set_with_expire :set

  def mapped_mget(*args)
    @client.mapped_mget(*args).inject({}){|h,k_v| h[k_v[0]] = YAML.load(k_v[1]); h}
  end
  alias :mget :mapped_mget

  def mset(*args)
    # flatten given hash/nested array
    if args.size == 1
      args = args.first.inject([]){|a,k_v| a << k_v[0]; a << k_v[1]; a}
    end

    # serialize all values [k1, v1, k2, v2, ...]
    args.size.times{|i| args[i] = args[i].to_yaml if i % 2 == 1 }

    @client.mset(*args)
  end
  alias :mapped_mset :mset

  def method_missing(name, *args, &block)
    @client.send(name, *args, &block)
  end
end