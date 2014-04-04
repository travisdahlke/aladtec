require_relative File.join('..','spec_helper')

describe 'configuration' do
  describe '.acc_id' do
    it 'should return default acc_id' do
      expect(AladtecClient.acc_id).to eq(AladtecClient::Configuration::DEFAULT_ACC_ID)
    end
  end

  describe '.acc_key' do
    it 'should return default acc_key' do
      expect(AladtecClient.acc_id).to eq(AladtecClient::Configuration::DEFAULT_ACC_KEY)
    end
  end

  describe '.cus_id' do
    it 'should return default cus_id' do
      expect(AladtecClient.acc_id).to eq(AladtecClient::Configuration::DEFAULT_CUS_ID)
    end
  end

  describe '.endpoint' do
    it 'should return default endpoint' do
      expect(AladtecClient.endpoint).to eq(AladtecClient::Configuration::DEFAULT_ENDPOINT)
    end
  end

  describe '.user_agent' do
    it 'should return default user agent' do
      expect(AladtecClient.user_agent).to eq(AladtecClient::Configuration::DEFAULT_USER_AGENT)
    end
  end

  describe '.method' do
    it 'should return default http method' do
      expect(AladtecClient.method).to eq(AladtecClient::Configuration::DEFAULT_METHOD)
    end
  end
end
