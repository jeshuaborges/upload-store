require_relative '../support/spec_helper'
require 'upload_store/policy_serializer'

describe UploadStore::PolicySerializer do
  class MyPolicy < Struct.new(:url, :path, :fields); end

  let(:policy) do
    MyPolicy.new('http://localhost/uploads', 'user123', {
      one: 'one',
      two: 'two'
    })
  end

  subject{ UploadStore::PolicySerializer.new(policy) }

  it 'serializes all required fields' do
    expect(subject.to_hash).to include({
      'upload-policy-provider'  => 'MyPolicy',
      'upload-policy-url'       => 'http://localhost/uploads',
      'upload-policy-path'      => 'user123'
    })
  end

  it 'includes provider specific fields' do
    expect(subject.to_hash).to include({'upload-policy-field-one' => 'one', 'upload-policy-field-two' => 'two'})
  end
end
