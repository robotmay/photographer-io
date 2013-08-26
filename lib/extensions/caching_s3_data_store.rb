module Dragonfly
  module DataStorage
    class CachingS3DataStore < S3DataStore
      attr_accessor :cache

      def store(*args)
        uid = super(*args)
        expire(uid)
        uid
      end

      def retrieve(uid)
        cache.fetch(cache_key_for(uid), expires_in: 5.minutes) do
          super(uid)
        end
      end

      def expire(uid)
        cache.delete cache_key_for(uid)
      end

      private

      def cache_key_for(uid)
        "dragonfly-#{uid}"
      end
    end
  end
end
