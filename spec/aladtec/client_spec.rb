require_relative File.join('..','spec_helper')

describe Aladtec::Client do
  let(:valid_keys) do
    Aladtec::Configuration::VALID_CONFIG_KEYS
  end

  describe "#members" do
    let(:members) { subject.members }
    before(:each) do
      stub_request(:post, "https://secure.emsmanager.net/api/index.php").
              with(body: hash_including({cmd: "getMembers"})).
              to_return(body: fixture('get_members.xml'))
    end
    it "returns a list of members" do
      expect(members.length).to eq(3)
    end

    let(:john) { members.first }
    it "returns members with names" do
      expect(john.name).to eq("John Anderson")
    end
    it "returns members with ids" do
      expect(john.id).to eq(32)
    end
  end

  describe "#events" do
    let(:events) { subject.events(begin_date: Date.today)}
    before(:each) do
      stub_request(:post, "https://secure.emsmanager.net/api/index.php").
              with(body: hash_including({cmd: "getEvents"})).
              to_return(body: fixture('get_events.xml'))
    end
    it "returns a list of events" do
      expect(events.length).to eq(2)
    end

    let(:event) { events.first }
    it "returns events with title" do
      expect(event.title).to eq("Game Night")
    end

    it "returns events with a description" do
      expect(event.description).to eq("Play games until the sun comes up!")
    end

    it "returns events with location" do
      expect(event.location).to eq("Public Library")
    end

    it "returns events with begin date" do
      expect(event.begin).to eq(Time.parse("2012-04-20"))
    end

    it "returns events with end date" do
      expect(event.end).to eq(Time.parse("2012-04-21 15:30:00 UTC"))
    end
  end

  describe "#schedules" do
    let(:schedules) { subject.schedules }
    before(:each) do
      stub_request(:post, "https://secure.emsmanager.net/api/index.php").
              with(body: hash_including({cmd: "getSchedules"})).
              to_return(body: fixture('get_schedules.xml'))
    end
    it "returns a list of schedules" do
      expect(schedules.length).to eq(5)
    end

    let(:schedule) { schedules.first }
    it "returns schedules with names" do
      expect(schedule.name).to eq("Sample BLS - 24/48")
    end

    it "returns schedules with ids" do
      expect(schedule.id).to eq(5)
    end
  end

  describe "#scheduled_now" do
    let(:schedules) { subject.scheduled_now }
    before(:each) do
      stub_request(:post, "https://secure.emsmanager.net/api/index.php").
              with(body: hash_including({cmd: "getScheduledTimeNow"})).
              to_return(body: fixture('get_scheduled_time_now.xml'))
    end
    it "returns a list of scheduled time now" do
      expect(schedules.length).to eq(2)
    end

    let(:schedule) { schedules.first }
    it "returns schedules with ids" do
      expect(schedule.id).to eq(5)
    end

    it "returns schedules with positions" do
      expect(schedule.positions.length).to eq(2)
    end
  end

  describe "#scheduled_range" do
    let(:ranges) { subject.scheduled_range(begin_time: Time.now, end_time: Time.now) }
    before(:each) do
      stub_request(:post, "https://secure.emsmanager.net/api/index.php").
              with(body: hash_including({cmd: "getScheduledTimeRanges"})).
              to_return(body: fixture('get_scheduled_time_ranges.xml'))
      stub_request(:post, "https://secure.emsmanager.net/api/index.php").
              with(body: hash_including({cmd: "getMembers"})).
              to_return(body: fixture('get_members.xml'))
      stub_request(:post, "https://secure.emsmanager.net/api/index.php").
              with(body: hash_including({cmd: "getSchedules"})).
              to_return(body: fixture('get_schedules.xml'))
    end
    it "returns a list of scheduled ranges" do
      expect(ranges.length).to eq(3)
    end

    let(:range) { ranges.first }
    it "returns ranges with a begin time" do
      expect(range.begin).to eq(Time.parse("2010-03-20T03:30:00Z"))
    end

    it "returns ranges with a end time" do
      expect(range.end).to eq(Time.parse("2010-03-20T11:30:00Z"))
    end

    it "returns ranges with a member id" do
      expect(range.member.id).to eq(42)
    end

    it "returns ranges with a position id" do
      expect(range.position.id).to eq(1)
    end

    it "returns ranges with a schedule id" do
      expect(range.schedule.id).to eq(5)
    end
  end

  context 'with module configuration' do
    before(:each) do
      Aladtec.configure do |config|
        valid_keys.each do |key|
          config.public_send("#{key}=", key)
        end
      end
    end

    after(:each) do
      Aladtec.reset
    end

    it "should inherit module configuration" do
      api = Aladtec::Client.new
      valid_keys.each do |key|
        expect(api.public_send(key)).to eq(key)
      end
    end
  end

  context 'with class configuration' do
    let(:config) do
      {
        :acc_id     => 'ai',
        :acc_key    => 'ak',
        :endpoint   => 'ep',
        :user_agent => 'ua',
        :method     => 'hm',
      }
    end

    it 'should override module configuration' do
      api = Aladtec::Client.new(config)
      valid_keys.each do |key|
        expect(api.public_send(key)).to eq(config[key])
      end
    end

    it 'should override module configuration after' do
      api = Aladtec::Client.new

      config.each do |key, value|
        api.public_send("#{key}=", value)
      end

      valid_keys.each do |key|
        expect(api.send("#{key}")).to eq(config[key])
      end
    end
  end
end
