require 'spec_helper'

require 'id_service/server'

describe IdService::Server do
  describe '#initialize' do
    it 'has sane defaults' do
      server = IdService::Server.new
      server.hostname.should eq('localhost')
      server.port.should eq(9000)
      server.host.should eq(1)
      server.worker.should eq(1)
      server.debug.should be_false
    end

    it 'accepts hostname option' do
      server = IdService::Server.new(hostname: 'id.example.org')
      server.hostname.should eq('id.example.org')
    end

    it 'accepts port option' do
      server = IdService::Server.new(port: 9111)
      server.port.should eq(9111)
    end

    it 'accepts host option' do
      server = IdService::Server.new(host: 5)
      server.host.should eq(5)
    end

    it 'accepts worker option' do
      server = IdService::Server.new(worker: 5)
      server.worker.should eq(5)
    end

    it 'accepts debug option' do
      server = IdService::Server.new(debug: true)
      server.debug.should be_true
    end
  end
end
