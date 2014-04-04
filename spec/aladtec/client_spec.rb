require_relative File.join('..','spec_helper')

describe Aladtec::Client do
  let(:keys) do
    Aladtec::Configuration::VALID_CONFIG_KEYS
  end

  describe 'with module configuration' do
    before(:each) do
      Aladtec.configure do |config|
        keys.each do |key|
          config.public_send("#{key}=", key)
        end
      end
    end

    after(:each) do
      Aladtec.reset
    end

    it "should inherit module configuration" do
      api = Aladtec::Client.new
      keys.each do |key|
        expect(api.public_send(key)).to eq(key)
      end
    end

    describe 'with class configuration' do
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
        keys.each do |key|
          expect(api.public_send(key)).to eq(config[key])
        end
      end

      it 'should override module configuration after' do
        api = Aladtec::Client.new

        config.each do |key, value|
          api.public_send("#{key}=", value)
        end

        keys.each do |key|
          expect(api.send("#{key}")).to eq(config[key])
        end
      end

    end

  end

end
