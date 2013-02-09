module UploadStore
  module Policy
    class Local
      include Configurable

      attr_reader :path, :url

      def initialize(opts={})
        @path = self.class.fetch_config(:path, opts)
        @url  = self.class.fetch_config(:url, opts)
      end

      def fields
        {}
      end
    end
  end
end
