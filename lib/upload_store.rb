require 'upload_store/version'
require 'active_support/core_ext/module/delegation'
require 'fog'
require 'upload_store/configuration'
require 'upload_store/configurable'
require 'upload_store/file'
require 'upload_store/policy'
require 'upload_store/policy/aws'
require 'upload_store/policy/local'

# Public: Uploads are all two stage. First files are uploaded from the client
# to the uploads directory where they are staged until they are processed
# and permanently moved to the photo directory. This is done to achieve the
# most platform flexibility possible. For our initial implementation we will be
# using XHR2 and CORS to upload files to S3 and then processing the uploaded
# files with another process. This means that rails doesn't have to be
# responsible for the connection while transferring the file.
module UploadStore
  include Configurable
  extend self

  def provider
    config.fetch(:provider)
  end

  def directory_name
    config.fetch(:directory)
  end

  def connection
    @connection ||= Fog::Storage.new(fog_configuration)
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
    connection.directories.get(directory_name)
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
      :key    => directory_name,
      :public => true
    })
  end

  def policy
    policy_class.new config
  end

  private

  def policy_class
    Policy.retrieve provider
  end

  # TODO: change to a configuration registration model and remove cyclomataic complexity.
  def fog_configuration
    case provider
    when 'AWS'
      {
        provider:               'AWS',
        aws_access_key_id:      config.fetch(:access_key_id),
        aws_secret_access_key:  config.fetch(:secret_access_key)
      }
    when 'Local'
      {
        provider:   'Local',
        local_root: config.fetch(:local_root),
      }
    else
      raise ArgumentError, "Provider '#{provider}' is not supported"
    end
  end
end
