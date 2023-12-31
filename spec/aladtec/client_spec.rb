# frozen_string_literal: true

require_relative File.join('..', 'spec_helper')

describe Aladtec::Client do
  let(:start_time) { Time.now.strftime('%FT%T%:z') }
  let(:end_time) { (Time.now + 60 * 60 * 24).strftime('%FT%T%:z') }
  let(:client_id) { 'foo' }
  let(:client_secret) { 'bar' }
  let(:endpoint) { subject.config.endpoint }

  before(:each) do
    subject.configure do |config|
      config.client_id = client_id
      config.client_secret = client_secret
    end
    stub_request(:post, URI.join(endpoint, 'oauth/token'))
      .to_return(body: { "access_token": "<string>", "token_type": "Bearer", "expires_in": 3600, "scope": "<string>" }.to_json,
                  headers: { 'Content-Type': 'application/json' })
  end

  describe '#members' do
    let(:members) { subject.members }
    before(:each) do
      stub_request(:get, URI.join(endpoint, 'members'))
        .to_return(body: fixture('members.json'),
                   headers: { 'Content-Type': 'application/json' })
    end
    it 'returns a list of members' do
      expect(members.length).to eq(1)
    end

    let(:ed) { members.first }
    it 'returns members with names' do
      expect(ed.name).to eq('John Smith')
    end
    it 'returns members with ids' do
      expect(ed.id).to eq(3)
    end
  end

  describe '#events' do
    let(:events) { subject.events(begin_time: start_time, end_time: end_time) }
    before(:each) do
      stub_request(:get, URI.join(endpoint, 'events'))
        .with(query: { range_start_datetime: start_time, range_stop_datetime: end_time })
        .to_return(body: fixture('events.json'),
                   headers: { 'Content-Type': 'application/json' })
    end
    it 'returns a list of events' do
      expect(events.length).to eq(3)
    end

    let(:event) { events.first }
    it 'returns events with title' do
      expect(event.title).to eq('EMS Monthly Meeting')
    end

    it 'returns events with a description' do
      expect(event.description).to eq('Open to the community')
    end

    it 'returns events with location' do
      expect(event.location).to eq('EMS Station')
    end

    it 'returns events with begin date' do
      expect(event.starts_at).to eq(Time.parse('2018-01-16T09:00-05:00'))
    end

    it 'returns events with end date' do
      expect(event.ends_at).to eq(Time.parse('2018-01-16T11:00-05:00'))
    end
  end

  describe '#schedules' do
    let(:schedules) { subject.schedules }
    before(:each) do
      stub_request(:get, URI.join(endpoint, 'schedules'))
        .to_return(body: fixture('schedules.json'),
                   headers: { 'Content-Type': 'application/json' })
    end
    it 'returns a list of schedules' do
      expect(schedules.length).to eq(2)
    end

    let(:schedule) { schedules.first }
    it 'returns schedules with names' do
      expect(schedule.name).to eq('Ambulance 1')
    end

    it 'returns schedules with ids' do
      expect(schedule.id).to eq(1)
    end
  end

  describe '#scheduled_now' do
    let(:schedules) { subject.scheduled_now }
    before(:each) do
      stub_request(:get, URI.join(endpoint, 'scheduled-time/members-scheduled-now'))
        .to_return(body: fixture('scheduled_time_now.json'),
                   headers: { 'Content-Type': 'application/json' })
    end
    it 'returns a list of scheduled time now' do
      expect(schedules.length).to eq(2)
    end

    let(:schedule) { schedules.first }
    it 'returns schedules with ids' do
      expect(schedule.id).to eq(1)
    end

    it 'returns schedules with positions' do
      expect(schedule.positions.length).to eq(1)
    end
  end

  describe '#scheduled_range' do
    let(:ranges) do
      subject.scheduled_range(begin_time: start_time,
                              end_time: end_time)
    end
    before(:each) do
      stub_request(:get, URI.join(endpoint, 'scheduled-time'))
        .with(query: { range_start_datetime: start_time, range_stop_datetime: end_time })
        .to_return(body: fixture('scheduled_time.json'),
                   headers: { 'Content-Type': 'application/json' })
    end
    it 'returns a list of scheduled ranges' do
      expect(ranges.length).to eq(4)
    end

    let(:range) { ranges.first }
    it 'returns ranges with a begin time' do
      expect(range.starts_at).to eq(Time.parse('2018-05-18T07:00'))
    end

    it 'returns ranges with a end time' do
      expect(range.ends_at).to eq(Time.parse('2018-05-19T07:00'))
    end

    it 'returns ranges with a member id' do
      expect(range.member_id).to eq(3)
    end

    it 'returns ranges with a position id' do
      expect(range.position_id).to eq(50)
    end

    it 'returns ranges with a schedule id' do
      expect(range.schedule_id).to eq(16)
    end
  end

  let(:valid_keys) { Aladtec.settings.keys }
  context 'with module configuration' do
    before(:each) do
      Aladtec.configure do |config|
        valid_keys.each do |key|
          config.public_send("#{key}=", key)
        end
      end
    end

    it 'should inherit module configuration' do
      api = Aladtec::Client.new
      valid_keys.each do |key|
        expect(api.config.public_send(key)).to eq(key)
      end
    end

    after(:each) do
      Aladtec.reset_config
    end
  end

  context 'with class configuration' do
    let(:config) do
      {
        client_id: 'ai',
        client_secret: 'ak',
        endpoint: 'ep',
        user_agent: 'ua'
      }
    end

    it 'should override module configuration' do
      api = Aladtec::Client.new(config)
      valid_keys.each do |key|
        expect(api.config.public_send(key)).to eq(config[key])
      end
    end

    it 'should override module configuration after' do
      api = Aladtec::Client.new

      config.each do |key, value|
        api.config.public_send("#{key}=", value)
      end

      valid_keys.each do |key|
        expect(api.config.send(key.to_s)).to eq(config[key])
      end
    end
  end
end
