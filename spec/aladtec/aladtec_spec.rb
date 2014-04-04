require_relative File.join('..','spec_helper')

describe Aladtec do
  it 'should have a version' do
    expect(Aladtec::VERSION).not_to be_nil
  end
end
