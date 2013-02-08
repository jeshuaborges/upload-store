require 'ostruct'

module UploadStore
  class Configuration < OpenStruct
    def fetch(key)
      value = self.send(key)

      unless value
        if block_given?
          yield
        else
          raise KeyError, "#{key} not found"
        end
      end

      value.respond_to?(:call) ? value.call : value
    end
  end
end
