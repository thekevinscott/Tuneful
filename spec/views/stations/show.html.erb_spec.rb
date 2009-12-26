require 'spec_helper'

describe "/stations/show.html.erb" do
  include StationsHelper
  before(:each) do
    assigns[:station] = @station = stub_model(Station)
  end

  it "renders attributes in <p>" do
    render
  end
end
