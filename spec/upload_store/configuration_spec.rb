require_relative '../support/spec_helper'
require 'upload_store/configuration'

describe UploadStore::Configuration do
  it 'raises errors when key could not be fetched' do
    expect{ subject.fetch(:ommitted_key) }.to raise_error(KeyError)
  end

  it 'returns value with fetch' do
    subject.foo = :bar
    expect(subject.fetch(:foo)).to eq(:bar)
  end

  it 'calls procs with fetch' do
    subject.foo = Proc.new { :bar }
    expect(subject.fetch(:foo)).to eq(:bar)
  end

  it 'yields for blocks when key is not found' do
    expect { |b| subject.fetch(:foo, &b) }.to yield_with_no_args
  end
end
