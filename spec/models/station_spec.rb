require 'spec_helper'

describe Station do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Station.create!(@valid_attributes)
  end
end
