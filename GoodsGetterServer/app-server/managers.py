# coding: utf-8

from redis import Redis

class RedisManager(object):
    KEY_PREFIX = "GoodsGetter"

    def __init__(self):
        self.redis_instance = Redis(host="redismaster", port=6379)

    def _generate_key(self, *args):
        key_part = "-".join([str(item) for item in args])
        return "-".join([self.KEY_PREFIX, key_part])
        
    def set_dict(self, data_dict, *args):
        key = self._generate_key(*args)
        self.redis_instance.hmset(key, data_dict)

    def get_dict(self, *args):
        key = self._generate_key(*args)
        return self.redis_instance.hgetall(key)
        
