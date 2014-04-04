require_relative File.join('..','spec_helper')

describe 'configuration' do
  AladtecClient::Configuration::VALID_CONFIG_KEYS.each do |key|
    describe ".#{key}" do
      it 'should return the default value' do
        expect(AladtecClient.public_send(key)).to eq(AladtecClient::Configuration.const_get("DEFAULT_#{key.upcase}"))
      end
    end
  end

  describe '.configure' do
    after(:each) do
      AladtecClient.reset
    end

    AladtecClient::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the #{key}" do
        AladtecClient.configure do |config|
          config.public_send("#{key}=", key)
          expect(AladtecClient.public_send(key)).to eq(key)
        end
      end
    end
  end
end
