require_relative '../support/spec_helper'
require 'upload_store/policy'

describe UploadStore::Policy do
  class UploadStore
    module Policy
      class MyPolicy; end
    end
  end

  it 'retrieves a class from an upload stores provider' do
    UploadStore.stub(:provider) { 'MyPolicy' }
    expect(UploadStore::Policy.retrieve).to eq( UploadStore::Policy::MyPolicy )
  end
end
