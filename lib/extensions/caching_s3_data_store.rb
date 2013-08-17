module Dragonfly
  module DataStorage
    class CachingS3DataStore < S3DataStore
      def retrieve(uid)
        cache.fetch(cache_key_for(uid), expires_in: 5.minutes) do
          super(uid)
        end
      end

      private

      def cache
        @cache ||= Dalli::Client.new
      end

      def cache_key_for(uid)
        "dragonfly-#{uid}"
      end
    end
  end
end
