require 'tempfile'

module UploadStore
  class File
    attr_reader :file

    # Public:
    #
    # file - Fog file.
    def initialize(file)
      @file = file
    end

    # Internal: Wraps the processing of the upload file. Ensures that upload is
    # properly cleaned up after processing.
    #
    # Returns a block result.
    def process(&blk)
      result = tempfile(&blk)

      # Should we add destroy to an ensure block? Im not sure if it makes sense
      # to delete failed files.
      file.destroy

      result
    end

    def name_parts
      parts = file.key.split('/').last.split('.')

      # Re-introduce the '.' for the file extension
      parts << ".#{parts.pop}"
    end

    def tempfile
      tmp = Tempfile.new(name_parts)

      tmp.binmode

      begin
        tmp.write(file.body)
        tmp.rewind
        yield tmp
      ensure
        tmp.close
        tmp.unlink
      end
    end

    def destroy
      file.destroy
    end
  end
end
