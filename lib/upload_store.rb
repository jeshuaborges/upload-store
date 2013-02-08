require 'upload_store/version'
require 'active_support/core_ext/module/delegation'
require 'fog'
require 'singleton'
require 'upload_store/file'

# Public: Uploads are all two stage. First files are uploaded from the client
# to the uploads directory where they are staged until they are processed
# and permanently moved to the photo directory. This is done to achieve the
# most platform flexibility possible. For our initial implementation we will be
# using XHR2 and CORS to upload files to S3 and then processing the uploaded
# files with another process. This means that rails doesn't have to be
# responsible for the connection while transferring the file.
class UploadStore
  include Singleton

  class << self
    delegate :configure, :connection, :directory, :create, :get, :AWS?, :provider, to: :instance
  end

  attr_accessor :fog_credentials, :fog_directory

  def configure
    yield self
  end

  def AWS?
    provider == 'AWS'
  end

  def provider
    fog_credentials[:provider]
  end

  def connection
    @connection ||= Fog::Storage.new(fog_credentials)
  end

  # Public: Photo storage directory.
  #
  # Returns a Fog directory instance.
  def directory
    @directory ||= get_directory || create_directory
  end

  # Internal: Gets or upload directory
  #
  # Returns a Fog directory instance.
  def get_directory
    connection.directories.get(fog_directory)
  end

  # Public: Create file from hash.
  #
  # Returns a Fog file instance.
  def create(opts)
    directory.files.create(opts)
  end

  # Public: Retrieve file from location.
  #
  # Returns a UploadFile instance.
  def get(filename)
    file = directory.files.get(filename)

    file ? UploadStore::File.new(file) : nil
  end

  # Internal: creates upload directory.
  #
  # Returns a Fog directory instance.
  def create_directory
    connection.directories.create({
      :key    => fog_directory,
      :public => true
    })
  end
end
