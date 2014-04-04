require_relative File.join('..','spec_helper')

describe 'configuration' do
  Aladtec::Configuration::VALID_CONFIG_KEYS.each do |key|
    describe ".#{key}" do
      it 'should return the default value' do
        expect(Aladtec.public_send(key)).to eq(Aladtec::Configuration.const_get("DEFAULT_#{key.upcase}"))
      end
    end
  end

  describe '.configure' do
    after(:each) do
      Aladtec.reset
    end

    Aladtec::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the #{key}" do
        Aladtec.configure do |config|
          config.public_send("#{key}=", key)
          expect(Aladtec.public_send(key)).to eq(key)
        end
      end
    end
  end
end
