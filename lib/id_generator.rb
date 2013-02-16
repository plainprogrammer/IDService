require 'active_support/core_ext'

#require 'celluloid'

require 'id_service/types'

class IdGenerator
  #include Celluloid

  # Project Epoch: Midnight, Mountain Time, January 1st, 2013
  EPOCH = 1357023600

  # Field Bit Lengths
  TIMESTAMP_BIT_LENGTH  = 40
  HOST_ID_BIT_LENGTH    = 5
  WORKER_ID_BIT_LENGTH  = 5
  SEQUENCE_BIT_LENGTH   = 14

  # Field Shifts
  TIMESTAMP_SHIFT = HOST_ID_BIT_LENGTH + WORKER_ID_BIT_LENGTH + SEQUENCE_BIT_LENGTH
  HOST_ID_SHIFT   = WORKER_ID_BIT_LENGTH + SEQUENCE_BIT_LENGTH
  WORKER_ID_SHIFT = SEQUENCE_BIT_LENGTH

  # Field Masks
  TIMESTAMP_MASK  = 0xFFFFFFFFFF000000
  HOST_ID_MASK    = 0x0000000000F80000
  WORKER_ID_MASK  = 0x000000000007C000
  SEQUENCE_MASK   = 0x0000000000003FFF

  def initialize(options = {})
    options.symbolize_keys!

    raise ArgumentError, 'missing host id' if options[:host].nil?
    raise ArgumentError, 'missing worker id' if options[:worker].nil?

    @debug      = options[:debug]
    @host       = options[:host].to_i
    @worker     = options[:worker].to_i
    @sequence   = 0
    @last_stamp = -1

    puts 'Initialized IdGenerator' if @debug
  end

  def get_id
    now = get_timestamp

    raise InvalidSystemClock if now < @last_stamp

    if @last_stamp == now
      @sequence = (@sequence + 1) & SEQUENCE_MASK

      if @sequence == 0
        sleep_until_next_millisecond
        now = get_timestamp
      end
    else
      @sequence = 0
    end

    @last_stamp = now

    id = (now << TIMESTAMP_SHIFT) | (@host << HOST_ID_SHIFT) | (@worker << WORKER_ID_SHIFT) | @sequence
    puts "Generated ID: #{id}" if @debug
    id
  end

  def get_timestamp
    Time.now.to_i - EPOCH
  end

  private

  def sleep_until_next_millisecond
    puts 'Waiting for next milliseconds' if @debug
    false until get_timestamp > @last_stamp
  end
end
