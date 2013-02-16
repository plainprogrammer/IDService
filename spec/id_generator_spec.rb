require 'spec_helper'

require 'id_generator'

require 'date'

describe IdGenerator do
  let(:generator) { IdGenerator.new({host: 1, worker: 1}) }
  let(:now) { Time.now.to_i - IdGenerator::EPOCH }

  describe '.initialize' do
    it 'requires a host id' do
      lambda {
        IdGenerator.new({worker: 1})
      }.should raise_error(ArgumentError, 'missing host id')
    end

    it 'requires a worker id' do
      lambda {
        IdGenerator.new({host: 1})
      }.should raise_error(ArgumentError, 'missing worker id')
    end
  end

  describe '#get_id' do
    it 'returns an integer' do
      generator.get_id.should be_a Integer
    end

    it 'properly masks the timestamp' do
      timestamp = (generator.get_id & 0xFFFFFFFFFF000000) >> 24
      timestamp.should be_within(1).of(now)
    end

    it 'properly masks the host id' do
      host_id = (generator.get_id & 0x0000000000F80000) >> 19
      host_id.should eq(1)
    end

    it 'properly masks the worker id' do
      worker_id = (generator.get_id & 0x000000000007C000) >> 14
      worker_id.should eq(1)
    end

    it 'properly masks the sequence number' do
      sequence = generator.get_id & 0x0000000000003FFF
      sequence.should eq(0)
    end

    it 'generates at least 10,000 ids per second' do
      start_time = Time.now.to_i
      100_000.times do
        generator.get_id
      end
      end_time = Time.now.to_i

      end_time.should be_within(10).of(start_time)
    end

    it 'does not produce duplicates' do
      ids = []
      100_000.times do
        ids << generator.get_id
      end

      ids.uniq.size.should eq(ids.size)
    end

    it 'is always sequential' do
      ids = []
      100_000.times do
        ids << generator.get_id
      end

      ids.each_index do |i|
        unless i == 0
          ids[i].should be > ids[i - 1]
        end
      end
    end

    it 'handles time running backwards gracefully' do
      now = Time.now

      generator.get_id

      Timecop.travel(now - 1) do
        lambda {
          generator.get_id
        }.should raise_error InvalidSystemClock
      end
    end
  end

  describe '#get_timestamp' do
    it 'returns an integer' do
      generator.get_timestamp.should be_a Integer
    end

    it 'returns seconds since its own epoch' do
      timestamp = generator.get_timestamp
      timestamp.should be_within(1).of(now)
    end
  end
end
