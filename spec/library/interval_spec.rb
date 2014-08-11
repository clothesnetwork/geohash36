require 'spec_helper'

describe Geohash36::Interval do
  context "[0, 6]" do
    subject { Geohash36::Interval.new([0, 6]) }

    its(:middle) { should == 3.0 }
    its(:third)  { should == 2.0 }
    its(:split2) { should == [[0, 3.0], [3.0, 6]] }
    its(:split3) { should == [[0, 2.0], [2.0, 4.0], [4.0, 6]] }
    its(:split)  { should == [[0, 1.0], [1.0, 2.0], [2.0, 3.0], [3.0, 4.0], [4.0, 5.0], [5.0, 6]] }

    context "when include all border" do
      it { is_expected.to     include?(0) }
      it { is_expected.to     include?(2) }
      it { is_expected.to     include?(6) }
      it { is_expected.to_not include?(9) }
    end

    context "when not include right border" do
      subject { Geohash36::Interval.new([0, 6], include_right: false) }

      it { is_expected.to     include?(0) }
      it { is_expected.to     include?(2) }
      it { is_expected.to_not include?(6) }
      it { is_expected.to_not include?(9) }
    end

    context "when not include left border" do
      subject { Geohash36::Interval.new([0, 6], include_left: false) }

      it { is_expected.to_not include?(0) }
      it { is_expected.to     include?(2) }
      it { is_expected.to     include?(6) }
      it { is_expected.to_not include?(9) }
    end

  end

end


