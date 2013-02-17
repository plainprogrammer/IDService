module IdService
  class Processor
    include ::Thrift::Processor
    include IdService::Helpers

    def process_get_id(seqid, iprot, oprot)
      args = read_args(iprot, GetIdArgs)
      result = GetIdResult.new()
      result.success = @handler.get_id()
      write_result(result, oprot, 'get_id', seqid)
    end
  end
end
