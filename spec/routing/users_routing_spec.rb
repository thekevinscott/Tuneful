require 'spec_helper'

describe UsersController do
  describe "routing" do

    it "recognizes and generates #login" do
      { :get => "/login" }.should route_to(:controller => "users", :action => "login")
    end

  end
end
