require 'spec_helper'

require 'id_generator'

require 'date'

describe IdGenerator do
  it 'defines its own epoch' do
    IdGenerator::EPOCH.should_not be_nil
  end

  it 'defines the TIMESTAMP_BIT_LENGTH' do
    IdGenerator::TIMESTAMP_BIT_LENGTH.should eq(40)
  end

  it 'defines the HOST_ID_BIT_LENGTH' do
    IdGenerator::HOST_ID_BIT_LENGTH.should eq(5)
  end

  it 'defines the WORKER_ID_BIT_LENGTH' do
    IdGenerator::WORKER_ID_BIT_LENGTH.should eq(5)
  end

  it 'defines the SEQUENCE_BIT_LENGTH' do
    IdGenerator::SEQUENCE_BIT_LENGTH.should eq(14)
  end

  it 'defines the TIMESTAMP_SHIFT' do
    IdGenerator::TIMESTAMP_SHIFT.should eq(24)
  end

  it 'defines the HOST_ID_SHIFT' do
    IdGenerator::HOST_ID_SHIFT.should eq(19)
  end

  it 'defines the WORKER_ID_SHIFT' do
    IdGenerator::WORKER_ID_SHIFT.should eq(14)
  end

  it 'defines the TIMESTAMP_MASK' do
    IdGenerator::TIMESTAMP_MASK.should eq(0xFFFFFFFFFF000000)
  end

  it 'defines the HOST_ID_MASK' do
    IdGenerator::HOST_ID_MASK.should eq(0x0000000000F80000)
  end

  it 'defines the WORKER_ID_MASK' do
    IdGenerator::WORKER_ID_MASK.should eq(0x000000000007C000)
  end

  it 'defines the SEQUENCE_MASK' do
    IdGenerator::SEQUENCE_MASK.should eq(0x0000000000003FFF)
  end

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

  describe '#get_next_id' do
    let(:generator) { IdGenerator.new({host: 1, worker: 1}) }
    let(:now) { Time.now.to_i - IdGenerator::EPOCH }

    it 'returns an integer' do
      generator.get_next_id.should be_a Integer
    end

    it 'properly masks the timestamp' do
      timestamp = (generator.get_next_id & IdGenerator::TIMESTAMP_MASK) >> IdGenerator::TIMESTAMP_SHIFT
      timestamp.should be_within(1).of(now)
    end

    it 'properly masks the host id' do
      host_id = (generator.get_next_id & IdGenerator::HOST_ID_MASK) >> IdGenerator::HOST_ID_SHIFT
      host_id.should eq(1)
    end

    it 'properly masks the worker id' do
      worker_id = (generator.get_next_id & IdGenerator::WORKER_ID_MASK) >> IdGenerator::WORKER_ID_SHIFT
      worker_id.should eq(1)
    end

    it 'properly masks the sequence number' do
      sequence = generator.get_next_id & IdGenerator::SEQUENCE_MASK
      sequence.should eq(0)
    end

    it 'generates at least 10,000 ids per second' do
      start_time = Time.now.to_i
      100_000.times do
        generator.get_next_id
      end
      end_time = Time.now.to_i

      end_time.should be_within(10).of(start_time)
    end

    it 'does not produce duplicates' do
      ids = []
      100_000.times do
        ids << generator.get_next_id
      end

      ids.uniq.size.should eq(ids.size)
    end

    it 'is always sequential' do
      ids = []
      100_000.times do
        ids << generator.get_next_id
      end

      ids.each_index do |i|
        unless i == 0
          ids[i].should be > ids[i - 1]
        end
      end
    end

    it 'handles time running backwards gracefully' do
      now = Time.now

      generator.get_next_id

      Timecop.travel(now - 1) do
        lambda {
          generator.get_next_id
        }.should raise_error InvalidSystemClock
      end
    end
  end

  describe '#get_timestamp' do
    let(:generator) { IdGenerator.new({host: 1, worker: 1}) }
    let(:now) { Time.now.to_i - IdGenerator::EPOCH }

    it 'returns an integer' do
      generator.get_timestamp.should be_a Integer
    end

    it 'returns seconds since its own epoch' do
      timestamp = generator.get_timestamp
      timestamp.should be_within(1).of(now)
    end
  end
end
