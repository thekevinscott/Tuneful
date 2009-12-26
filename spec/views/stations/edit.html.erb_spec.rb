require 'spec_helper'

describe "/stations/edit.html.erb" do
  include StationsHelper

  before(:each) do
    assigns[:station] = @station = stub_model(Station,
      :new_record? => false
    )
  end

  it "renders the edit station form" do
    render

    response.should have_tag("form[action=#{station_path(@station)}][method=post]") do
    end
  end
end
