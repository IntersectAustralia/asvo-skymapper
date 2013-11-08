require 'spec_helper'

describe ImageQuery do

  # Validate Right Ascension (RA)
  it { should allow_value('0').for(:ra) }
  it { should allow_value('359.999999').for(:ra) }
  it { should allow_value('123.123456').for(:ra) }
  it { should allow_value('1.123456').for(:ra) }
  it { should allow_value('.123456').for(:ra) }
  it { should allow_value('   .123456    ').for(:ra) }

  it { should_not allow_value('-0.00000001').for(:ra) }
  it { should_not allow_value('360').for(:ra) }
  it { should_not allow_value('1000').for(:ra) }
  it { should_not allow_value('-1000').for(:ra) }
  it { should_not allow_value('.123456789').for(:ra) }
  it { should_not allow_value(nil).for(:ra) }
  it { should_not allow_value('').for(:ra) }
  it { should_not allow_value('7abc').for(:ra) }
  it { should_not allow_value('.').for(:ra) }
  it { should_not allow_value(' 1.  ').for(:ra) }

  # Validate Declination (DEC)
  it { should allow_value('-90').for(:dec) }
  it { should allow_value('90').for(:dec) }
  it { should allow_value('0').for(:dec) }
  it { should allow_value('1.123456').for(:dec) }
  it { should allow_value('-1.123456').for(:dec) }
  it { should allow_value('   -.123456    ').for(:dec) }

  it { should_not allow_value('-90.00000001').for(:dec) }
  it { should_not allow_value('90.00000001').for(:dec) }
  it { should_not allow_value('1000').for(:dec) }
  it { should_not allow_value('-1000').for(:dec) }
  it { should_not allow_value('1.123456789').for(:dec) }
  it { should_not allow_value('-1.123456789').for(:dec) }
  it { should_not allow_value(nil).for(:dec) }
  it { should_not allow_value('').for(:dec) }
  it { should_not allow_value('7abc').for(:dec) }
  it { should_not allow_value('.').for(:dec) }
  it { should_not allow_value(' -  1.  ').for(:dec) }

end