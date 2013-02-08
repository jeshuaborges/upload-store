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
    config.provider   = 'AWS'
    access_key_id:    = ENV['AWS_ACCESS_KEY_ID']
    secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    config.directory  = 'my-bucket-name'
    config.path       = 'directory-for-everyone'
  end
else
  UploadStore.configure do |config|
    config.provider   = 'Local'
    config.local_root = Rails.root.join('tmp')
    config.directory  = 'upload-store-unit-tests'
    config.path       = 'directory-for-everyone'
    config.url        = 'http://localhost:3000/uploads'
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
