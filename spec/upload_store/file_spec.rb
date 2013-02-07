require_relative '../support/spec_helper'
require 'fog'
require 'upload_store/file'

# Unit tests
describe UploadStore::File do
  let(:decorated) { double(:file, destroy: true, body: 'body', key: 'key.ext') }
  let(:file) { UploadStore::File.new(decorated) }


  it 'splits name parts to preserve the file extension' do
    expect(file.name_parts).to eql(['key', '.ext'])
  end

  it 'process deletes the uploaded file' do
    decorated.should_receive(:destroy)
    file.process {|file| }
  end

  it 'process returns the value of the block' do
    val = file.process {|file| 'block_value' }
    expect(val).to eql('block_value')
  end
end

# Functional tests
describe UploadStore::File do
  before do
    # This is a lot of work to set up but its very worth it to ensure that
    # this core processing logic is functioning as expected.

    temp_directory = File.expand_path('../tmp', __FILE__)

    connection = Fog::Storage.new({
      provider:   'Local',
      local_root: temp_directory,
      endpoint:   temp_directory
    })

    directory = connection.directories.create(key: 'fog-test')

    @fog_file = directory.files.create(
      :key    => 'world-bar.jpeg',
      :body   => File.open(File.expand_path('./spec/fixtures/jpeg.jpeg')),
      :public => true
    )

    @upload_file = UploadStore::File.new(@fog_file)
  end

  it 'uses the file extension with the tempfile' do
    @upload_file.process do |file|
      expect(file.path).to end_with('.jpeg')
    end
  end
end
