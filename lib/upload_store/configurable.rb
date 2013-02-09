require 'upload_store/configuration'

module UploadStore
  module Configurable
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def configure(&blk)
        blk.call config
      end

      def config
        @config ||= Configuration.new
      end

      def fetch_config(key, opts={})
        opts.fetch(key) { config.fetch(key) }
      end
    end
  end
end
