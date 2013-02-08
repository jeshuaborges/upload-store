require 'securerandom'
require 'active_support/json'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/numeric/bytes'
require 'active_support/core_ext/object/to_json'

class UploadStore
  module Policy
    class AWS
      attr_reader :expiration, :path, :max_file_size

      class << self
        CONFIG_KEYS = [:access_key_id, :secret_access_key, :bucket]

        attr_accessor *CONFIG_KEYS

        def configure
          yield self
        end

        def assert_config!
          CONFIG_KEYS.each do |config|
            raise ArgumentError, "Missing configuration '#{config}'" unless self.send(config)
          end
        end
      end

      def initialize(opts={})
        @path           = opts.fetch(:path)
        @expiration     = opts.fetch(:expiration)
        @max_file_size  = opts.fetch(:max_file_size)
      end

      def fields
        self.class.assert_config!

        {
          key:            key,
          acl:            acl,
          policy:         policy,
          signature:      signature,
          AWSAccessKeyId: self.class.access_key_id
        }
      end

      def provider
        'AWS'
      end

      def url
        "https://#{self.class.bucket}.s3.amazonaws.com/"
      end

      protected

      def key
        "#{path}/${filename}"
      end

      def acl
        'public-read'
      end

      def policy
        Base64.encode64(policy_data.to_json).gsub("\n", "")
      end

      def policy_data
        {
          expiration: expiration,
          conditions: [
            ['starts-with', '$key', 'uploads/'],
            ['content-length-range', 0, max_file_size],
            {bucket: self.class.bucket},
            {acl: acl}
          ]
        }
      end

      def signature
        Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest::Digest.new('sha1'),
            self.class.secret_access_key, policy
          )
        ).gsub("\n", "")
      end
    end
  end
end
