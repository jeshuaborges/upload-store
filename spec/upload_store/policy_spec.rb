require_relative '../support/spec_helper'
require 'upload_store/policy'

describe UploadStore::Policy do
  module UploadStore
    module Policy
      class MyPolicy; end
    end
  end

  it 'retrieves a class from an upload stores provider' do
    expect(subject.retrieve('MyPolicy')).to eq( UploadStore::Policy::MyPolicy )
  end
end
