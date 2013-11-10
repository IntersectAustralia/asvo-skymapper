require 'spec_helper'

describe MagnitudeFilter do

  # Validate name
  it { should allow_value('test').for(:name) }
  it { should_not allow_value('    ').for(:name) }

  # Validate min
  it { should allow_value('0').for(:min) }
  it { should allow_value('0.123').for(:min) }
  it { should allow_value('.123').for(:min) }
  it { should allow_value('100000000').for(:min) }
  it { should allow_value('-100000000').for(:min) }
  it { should allow_value('   -100000000   ').for(:min) }

  it { should_not allow_value('0.123456789').for(:min) }
  it { should_not allow_value('7abc').for(:min) }
  it { should_not allow_value('.').for(:min) }
  it { should_not allow_value('123.').for(:min) }

  # Validate max
  it { should allow_value('0').for(:max) }
  it { should allow_value('0.123').for(:max) }
  it { should allow_value('.123').for(:max) }
  it { should allow_value('100000000').for(:max) }
  it { should allow_value('-100000000').for(:max) }
  it { should allow_value('   -100000000   ').for(:max) }

  it { should_not allow_value('0.123456789').for(:max) }
  it { should_not allow_value('7abc').for(:max) }
  it { should_not allow_value('.').for(:max) }
  it { should_not allow_value('123.').for(:max) }

  # Validate max > min
  it 'max must be greater than min' do
    f = MagnitudeFilter.new(min:0)
    f.max = '0'
    f.valid?
    f.errors[:max].should_not be_empty
    f.max = '-1'
    f.valid?
    f.errors[:max].should_not be_empty
    f.max = '2'
    f.valid?
    f.errors[:max].should be_empty
  end

  # Validate min or max presence
  it 'min or max must be present' do
    f = MagnitudeFilter.new
    f.valid?
    f.errors[:min].should_not be_empty
    f.errors[:max].should_not be_empty
    f.max = '0'
    f.valid?
    f.errors[:min].should be_empty
    f.errors[:max].should be_empty
    f.max = nil
    f.valid?
    f.errors[:min].should_not be_empty
    f.errors[:max].should_not be_empty
    f.min = '0'
    f.valid?
    f.errors[:min].should be_empty
    f.errors[:max].should be_empty
  end

end