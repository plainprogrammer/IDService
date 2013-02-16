require 'spec_helper'

describe 'ID Service' do
  let(:response_body) { JSON.parse(page.body) }

  describe 'GET /id' do
    before :each do
      visit id_url
    end

    it 'returns an integer in the \'id\' field' do
      response_body['id'].should be_a Integer
    end

    it 'returns only unique ids' do
      ids = []

      1_000.times do
        visit id_url
        ids << response_body['id']
      end

      ids.uniq.size.should eq(ids.size)
    end

    it 'returns only sequential ids' do
      ids = []

      1_000.times do
        visit id_url
        ids << response_body['id']
      end

      ids.each_index do |i|
        unless i == 0
          ids[i].should be > ids[i - 1]
        end
      end
    end

    it 'returns ids very fast (500 ids/sec)' do
      start_time = Time.now.to_i

      5_000.times do
        visit id_url
      end

      end_time = Time.now.to_i

      end_time.should be_within(10).of(start_time)
    end
  end
end
