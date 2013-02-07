# UploadStore

Rails is terrible at streaming uploaded files. So, move that upload handling to what ever file store your already using and rely on ruby to handle the processing.

## Installation

Add this line to your application's Gemfile:

    gem 'upload-store'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install upload-store

## Usage

Configuration

```ruby
require 'upload_store'

if %w(staging production).include?(Rails.env)
  UploadStore.configure do |config|
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
    config.fog_directory   = 'my_bucket_name'
  end
else
  UploadStore.configure do |config|
    config.fog_directory    = 'uploads'
    config.fog_credentials  = {
      provider:   'Local',
      local_root: Rails.root.join('tmp')
    }
  end
end
```

Usage

```ruby
UploadStore.get('file_name.jpg').process do |file|
  # anything you want with a local file here
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
