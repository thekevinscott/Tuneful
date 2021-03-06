require 'spec_helper'

describe StationsController do

  def mock_station(stubs={})
    @mock_station ||= mock_model(Station, stubs)
  end

  describe "GET index" do
    it "assigns all stations as @stations" do
      Station.stub!(:find).with(:all).and_return([mock_station])
      get :index
      assigns[:stations].should == [mock_station]
    end
  end

  describe "GET show" do
    it "assigns the requested station as @station" do
      #Station.stub!(:find).with("37").and_return(mock_station)
      #get :show, :id => "37"
      #assigns[:station].should equal(mock_station)
    end
  end

  describe "GET new" do
    it "assigns a new station as @station" do
      Station.stub!(:new).and_return(mock_station)
      get :new
      assigns[:station].should equal(mock_station)
    end
  end

  describe "GET edit" do
    it "assigns the requested station as @station" do
      Station.stub!(:find).with("37").and_return(mock_station)
      get :edit, :id => "37"
      assigns[:station].should equal(mock_station)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created station as @station" do
        Station.stub!(:new).with({'these' => 'params'}).and_return(mock_station(:save => true))
        post :create, :station => {:these => 'params'}
        assigns[:station].should equal(mock_station)
      end

      it "redirects to the created station" do
        Station.stub!(:new).and_return(mock_station(:save => true))
        post :create, :station => {}
        response.should redirect_to(station_url(mock_station))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved station as @station" do
        Station.stub!(:new).with({'these' => 'params'}).and_return(mock_station(:save => false))
        post :create, :station => {:these => 'params'}
        assigns[:station].should equal(mock_station)
      end

      it "re-renders the 'new' template" do
        Station.stub!(:new).and_return(mock_station(:save => false))
        post :create, :station => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested station" do
        Station.should_receive(:find).with("37").and_return(mock_station)
        mock_station.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :station => {:these => 'params'}
      end

      it "assigns the requested station as @station" do
        Station.stub!(:find).and_return(mock_station(:update_attributes => true))
        put :update, :id => "1"
        assigns[:station].should equal(mock_station)
      end

      it "redirects to the station" do
        Station.stub!(:find).and_return(mock_station(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(station_url(mock_station))
      end
    end

    describe "with invalid params" do
      it "updates the requested station" do
        Station.should_receive(:find).with("37").and_return(mock_station)
        mock_station.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :station => {:these => 'params'}
      end

      it "assigns the station as @station" do
        Station.stub!(:find).and_return(mock_station(:update_attributes => false))
        put :update, :id => "1"
        assigns[:station].should equal(mock_station)
      end

      it "re-renders the 'edit' template" do
        Station.stub!(:find).and_return(mock_station(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested station" do
      Station.should_receive(:find).with("37").and_return(mock_station)
      mock_station.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the stations list" do
      Station.stub!(:find).and_return(mock_station(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(stations_url)
    end
  end

end
