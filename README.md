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
    config.directory  = 'my-bucket-name'
    config.path       = 'directory-for-everyone'

    # AWS configs
    access_key_id:    = ENV['AWS_ACCESS_KEY_ID']
    secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  end
else
  UploadStore.configure do |config|
    config.provider   = 'Local'
    config.directory  = 'upload-store-unit-tests'
    config.path       = 'directory-for-everyone'

    # Local configs
    config.local_root = Rails.root.join('tmp')
    config.url        = 'http://localhost:3000/uploads'
  end
end
```

Usage

```ruby
UploadStore.get('file_name.jpg').process do |file|
  # Anything you want with a local file here.
  # Example: User.avatar.store!(file)
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
