require 'spec_helper'

describe "/stations/index.html.erb" do
  include StationsHelper

  before(:each) do
    assigns[:stations] = [
      stub_model(Station),
      stub_model(Station)
    ]
  end

  it "renders a list of stations" do
    render
  end
end
