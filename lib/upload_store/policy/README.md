# UploadStore::Policy

Policies handle all the heavy lifting of creating signatures and defining parameters to be passed to the current upload store. There is not much work to be done when posting to local however posting to S3 requires many parameters.

## Configuration

```ruby
UploadStore::Policy::AWS.configure do |config|
  config.access_key_id      = ENV['AWS_ACCESS_KEY_ID']
  config.secret_access_key  = ENV['AWS_SECRET_ACCESS_KEY']
  config.bucket             = 'my-uploads'
  config.path               = Proc.new{ "uploads/#{SecureRandom.hex(4)}" }
  config.expiration         = Proc.new{ 10.hours.from_now }
  consig.max_file_size      = 100.megabytes
end
```

```ruby
UploadStore::Policy::Local.configure do |config|
  config.url  = 'http://localhost:3000/uploads'
  config.path = Proc.new{ "uploads/#{SecureRandom.hex(4)}" }
end
```

## Usage

One way policies can be used is to write meta headers to pages requiring a form. These fields can be pulled via javascript and posted to the destination URL with the file to be uploaded.

```ruby
require 'upload_store/policy'
require 'upload_store/policy_serializer'

module UploadStoreHelper
  def meta_tag(key, value)
    content_tag(:meta, nil, name: key, content: value)
  end

  def upload_policy
    UploadStore::Policy.retrieve.new(
      path:           "uploads/#{current_user.id}",
      max_file_size:  10.megabytes,
      expiration:     1.hour.from_now
    )
  end

  def upload_store_meta_tags
    serializer = UploadStore::PolicySerializer.new(upload_policy)

    serializer.to_hash.map{|k,v| meta_tag(k, v)}.join("\n").html_safe
  end
end
```

## Policy requirements

`#url`: Path the url which can receive the http multipart post including the file.

`#path`: Relative path the server should use to store files posted. This should not include a file name. For example posting file `bar.jpeg` with path `foo` should cause the server to create the file `foo/bar.jpeg`.
