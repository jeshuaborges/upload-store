require_relative '../support/spec_helper'
require 'upload_store/configurable'

describe UploadStore::Configurable do
  class Foo
    include UploadStore::Configurable
  end

  it 'allows for configuration' do
    Foo.configure do |config|
      config.foo = :bar
    end

    expect(Foo.config.foo).to eq(:bar)
  end

  it 'fetch a config from the passed object' do
    expect(Foo.fetch_config(:object_key, object_key: 'something')).to eql('something')
  end

  it 'will fall back to  fetching config from config' do
    expect(Foo.fetch_config(:foo)).to eql(:bar)
  end

end
