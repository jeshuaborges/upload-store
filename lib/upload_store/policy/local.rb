class UploadStore
  module Policy
    class Local
      attr_reader :path, :url

      def initialize(opts={})
        @path = opts.fetch(:path)
        @url  = opts.fetch(:url)
      end

      def fields
        {}
      end
    end
  end
end
