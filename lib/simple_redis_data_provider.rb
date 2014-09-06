class SimpleRedisDataProvider < Struct.new(:name_space, :connection)
  def get(ns, name)
    namespaced_redis.hget ns, name
  end

  def set(ns, name, value)
    namespaced_redis.hset ns, name, value
  end

  def flush
    keys = namespaced_redis.keys('*')
    namespaced_redis.del(keys) unless keys.blank?
  end

  private
  def namespaced_redis
    @_namespaced_redis ||= Redis::Namespace.new(name_space, redis: connection)
  end
end