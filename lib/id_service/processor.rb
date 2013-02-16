module IdService
  class Processor
    include ::Thrift::Processor

    def process_get_id(seqid, iprot, oprot)
      args = read_args(iprot, Get_id_args)
      result = Get_id_result.new()
      result.success = @handler.get_id()
      write_result(result, oprot, 'get_id', seqid)
    end
  end
end
