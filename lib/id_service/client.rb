require 'thrift'

require 'active_support/core_ext'

require 'id_service/types'
require 'id_service/helpers'

module IdService
  class Client
    include ::Thrift::Client

    def initialize(options = {})
      options.symbolize_keys!
      options = default_options.merge(options)

      @transport = Thrift::BufferedTransport.new(Thrift::Socket.new(options[:host], options[:port]))
      protocol = Thrift::BinaryProtocol.new(@transport)

      @iprot = protocol
      @oprot = options[:oprot] || protocol
      @seqid = 0
    end

    def open
      @transport.open
    end

    def get_id()
      send_get_id()
      return recv_get_id()
    end

private

    def default_options
      {
          host:   'localhost',
          port:   9000,
          oprot:  nil
      }
    end

    def send_get_id()
      send_message('get_id', Get_id_args)
    end

    def recv_get_id()
      result = receive_message(Get_id_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'get_id failed: unknown result')
    end

  end

end
