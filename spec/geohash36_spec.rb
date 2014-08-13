require 'spec_helper'

describe Geohash36 do
  it { expect{Geohash36.new 111 }.to raise_error(ArgumentError) }
  it { expect{Geohash36.new "BB99999999"}.not_to raise_error }
  it { expect{Geohash36.new latitude: 1, longitude: 2}.not_to raise_error }

  context "when default args" do
    context "coordinates" do
      subject { Geohash36.new }

      let(:default_coords)  { {latitude: 0, longitude: 0} }
      let(:default_hash)    { 'l222222222' }
      let(:some_coords)     { {latitude: 54, longitude: 32} }
      let(:some_hash)       { 'BB99999999' }

      its(:coords) { is_expected.to eq(default_coords)}
      its(:hash)   { is_expected.to eq(default_hash)}

      it "should change coords when hash updated" do
        expect{subject.hash = some_hash}.to change{subject.coords}
      end

      it "should change hash when coords updated" do
        expect{subject.coords = some_coords}.to change{subject.hash}
      end

      it "should give appropriate hash for coords" do
        subject.coords = some_coords
        expect(subject.hash).to eq(some_hash)
      end

      it "should give appropriate coords for hash" do
        subject.accuracy = 2
        subject.hash = some_hash
        expect(subject.coords).to eq(some_coords)
      end

      it { expect{subject.hash = ""}.to raise_error(ArgumentError) }
    end

  end


end
