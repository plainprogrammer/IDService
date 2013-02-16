require 'thrift'
require 'id_service/types'

module IdService
  class Client
    include ::Thrift::Client

    def get_id()
      send_get_id()
      return recv_get_id()
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
