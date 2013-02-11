require 'securerandom'
require 'active_support/json'
require 'active_support/core_ext/object/to_json'

module UploadStore
  module Policy
    class AWS
      include Configurable

      attr_reader :expiration, :path, :max_file_size, :directory, :access_key_id, :secret_access_key

      def initialize(opts={})
        @access_key_id      = fetch_config(:access_key_id, opts)
        @secret_access_key  = fetch_config(:secret_access_key, opts)
        @directory          = fetch_config(:directory, opts)
        @path               = fetch_config(:path, opts)
        @expiration         = fetch_config(:expiration, opts)
        @max_file_size      = fetch_config(:max_file_size, opts)
      end

      def fields
        {
          key:            key,
          AWSAccessKeyId: access_key_id,
          acl:            acl,
          policy:         policy,
          signature:      signature
        }
      end

      def bucket; directory; end

      def provider
        'AWS'
      end

      def url
        "https://#{bucket}.s3.amazonaws.com/"
      end

      protected

      def key
        "#{path}/${filename}"
      end

      def acl
        'public-read'
      end

      def policy
        @policy ||= Base64.encode64(policy_data.to_json).gsub("\n", "")
      end

      def policy_data
        {
          expiration: expiration,
          conditions: [
            ['starts-with', '$key', "#{path}/"],
            ['content-length-range', 0, max_file_size],
            {bucket: bucket},
            {acl: acl}
          ]
        }
      end

      def signature
        Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest::Digest.new('sha1'),
            secret_access_key, policy
          )
        ).gsub("\n", "")
      end

      private

      def fetch_config(*args)
        self.class.fetch_config(*args)
      end
    end
  end
end
