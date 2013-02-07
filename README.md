# Upload::Store

Rails is terrible at streaming uploaded files. So, move that upload handling to what ever file store your already using and rely on ruby to handle the processing.

## Installation

Add this line to your application's Gemfile:

    gem 'upload-store'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install upload-store

## Usage

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
