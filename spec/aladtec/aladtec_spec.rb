# frozen_string_literal: true

require_relative File.join('..', 'spec_helper')

describe Aladtec do
  it 'should have a version' do
    expect(Aladtec::VERSION).not_to be_nil
  end

  describe '.configure' do
    Aladtec.settings.keys.each do |key|
      it "should set the #{key}" do
        Aladtec.configure do |config|
          config.public_send("#{key}=", key)
        end
        expect(Aladtec.config.public_send(key)).to eq(key)
      end
    end

    after(:each) do
      Aladtec.reset_config
    end
  end
end
