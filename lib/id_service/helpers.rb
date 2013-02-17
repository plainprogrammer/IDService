require 'thrift'

module IdService
  module Helpers
    class GetIdArgs
      include ::Thrift::Struct
      include ::Thrift::Struct_Union

      FIELDS = {}

      def struct_fields; FIELDS; end

      def validate; end

      ::Thrift::Struct.generate_accessors self
    end

    class GetIdResult
      include ::Thrift::Struct
      include ::Thrift::Struct_Union

      SUCCESS = 0

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::I64, :name => 'success'}
      }

      def struct_fields; FIELDS; end

      def validate; end

      ::Thrift::Struct.generate_accessors self
    end
  end
end
