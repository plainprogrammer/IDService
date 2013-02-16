require 'spec_helper'

require 'id_service/server'
require 'id_service/client'

describe 'ID Service' do
  before :all do
    @client = IdService::Client.new
    @client.open
  end

  describe '#get_id' do
    it 'returns an integer' do
      @client.get_id.should be_a Integer
    end

    it 'returns only unique ids' do
      ids = []

      10_000.times do
        ids << @client.get_id
      end

      ids.uniq.size.should eq(ids.size)
    end

    it 'returns only sequential ids' do
      ids = []

      10_000.times do
        ids << @client.get_id
      end

      ids.each_index do |i|
        unless i == 0
          ids[i].should be > ids[i - 1]
        end
      end
    end

    it 'returns ids very fast (1,000 ids/sec)' do
      start_time = Time.now.to_i

      10_000.times do
        @client.get_id
      end

      end_time = Time.now.to_i

      end_time.should be_within(10).of(start_time)
    end
  end
end
