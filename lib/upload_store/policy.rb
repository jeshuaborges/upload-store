require 'upload_store/policy/local'
require 'upload_store/policy/aws'

module UploadStore
  module Policy
    def self.retrieve(provider_name)
      const_get provider_name
    end
  end
end
