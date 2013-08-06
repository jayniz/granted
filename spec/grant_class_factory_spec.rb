require 'spec_helper'

describe Granted::GrantClassFactory do
  before(:all){ Granted::GrantClassFactory.create(:publish) }

  it "has the right type" do
    Granted::PublishGrant.new.class.name.should == 'Granted::PublishGrant'
  end

  it "creating the same class again doesn't hurt" do
    expect{
      Granted::GrantClassFactory.create(:double)
      Granted::GrantClassFactory.create(:double)
      Granted::GrantClassFactory.create(:double)
    }.to_not raise_error
  end
end
