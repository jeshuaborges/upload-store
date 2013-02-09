require_relative '../../support/spec_helper'
require 'upload_store/policy/aws'

describe UploadStore::Policy::AWS do
  subject do
    UploadStore::Policy::AWS.new(
      access_key_id:      'AWS_ACCESS_KEY_ID',
      secret_access_key:  'AWS_SECRET_ACCESS_KEY',
      directory:          'UPLOAD_STORE_S3_BUCKET',
      path:               'directory-for-files',
      expiration:         Time.local(2015),
      max_file_size:      100_000_000
    )
  end

  it 'returns all fields required for an aws s3 form policy' do
    expect(subject.fields.keys).to include(:key, :acl, :policy, :signature, :AWSAccessKeyId)
  end
end
