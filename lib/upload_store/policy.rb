require 'upload_store/policy/local'
require 'upload_store/policy/aws'

class UploadStore
  module Policy
    def self.retrieve
      const_get UploadStore.provider
    end
  end
end
