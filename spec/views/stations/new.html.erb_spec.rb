require 'spec_helper'

describe "/stations/new.html.erb" do
  include StationsHelper

  before(:each) do
    assigns[:station] = stub_model(Station,
      :new_record? => true
    )
  end

  it "renders new station form" do
    render

    response.should have_tag("form[action=?][method=post]", stations_path) do
    end
  end
end
