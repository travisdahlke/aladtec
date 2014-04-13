require_relative File.join('..','spec_helper')

describe Aladtec::RangeDenormalizer do
  let(:members) {[OpenStruct.new(id: 1, name: "Joe Schmoe"), OpenStruct.new(id: 2, name: "Ann Perkins")]}
  let(:schedules) {
    [OpenStruct.new(id: 1, name: "Daytime", positions: [OpenStruct.new(id: 3, name: "Firefighter")]),
     OpenStruct.new(id: 2, name: "Nighttime", positions: [OpenStruct.new(id: 3, name: "Firefighter")])]
  }
  subject { Aladtec::RangeDenormalizer.new(members: members, schedules: schedules) }

  describe "#denormalize" do
    let(:ranges) {[OpenStruct.new(member: OpenStruct.new(id: 1), schedule: OpenStruct.new(id: 2), position: OpenStruct.new(id: 3))]}
    it "should map members to ranges" do
      expect(subject.denormalize(ranges).first.member.name).to eq("Joe Schmoe")
    end

    it "should map schedules to ranges" do
      expect(subject.denormalize(ranges).first.schedule.name).to eq("Nighttime")
    end

    it "should map positions to ranges" do
      expect(subject.denormalize(ranges).first.position.name).to eq("Firefighter")
    end
  end
end
