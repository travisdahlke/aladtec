require_relative File.join('..','spec_helper')

describe Aladtec::Client do
  let(:valid_keys) do
    Aladtec::Configuration::VALID_CONFIG_KEYS
  end

  describe "#members" do
    before(:each) do
      stub_request(:post, "https://secure.emsmanager.net/api/index.php").
              with(body: hash_including({cmd: "getMembers"})).
              to_return(body: fixture('get_members.xml'))
    end
    it "returns a list of members" do
      expect(subject.members.length).to eq(3)
    end

    let(:john) { subject.members.first }
    it "creates members with names" do
      expect(john.name).to eq("John Anderson")
    end
    it "creates members with ids" do
      expect(john.id).to eq(32)
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
        :cus_id     => 'ci',
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
