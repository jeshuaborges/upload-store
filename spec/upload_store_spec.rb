require_relative 'support/spec_helper'
require 'upload_store'

# Unit tests
describe UploadStore do
  before do
    subject.configure do |config|
      config.provider   = 'Local'
      config.local_root = File.expand_path('../../tmp', __FILE__)
      config.directory  = 'upload-store-unit-tests'
      config.path       = 'directory-for-everyone'
      config.url        = 'http://localhost:3000/uploads'
    end
  end

  it 'creates a connection' do
    fog_storage = double('fog_storage')
    stub_const('Fog::Storage', fog_storage)
    fog_storage.should_receive(:new)

    subject.connection
  end

  it 'it returns the upload directory' do
    subject.stub(:create_directory)
    subject.should_receive(:get_directory)
    subject.directory
  end

  it 'creates the upload directory if it doesnt exist' do
    subject.stub(:get_directory) { nil }
    subject.should_receive(:create_directory)
    subject.directory
  end

  it 'creates a policy' do
    expect(subject.policy).to be_a(UploadStore::Policy::Local)
  end
end
