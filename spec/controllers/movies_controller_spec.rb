require 'spec_helper'

describe MoviesController do
  
  describe 'searching TMDb' do
    before :each do
      @fake_results=[double('movie1'),double('movie2')]
    end
    it 'should call the model method that performs TMBb search' do
      Movie.should_receive(:find_in_tmdb).with('parkland').and_return(@fake_results)
      post :search_tmdb, {"search_form"=>{"term"=>'parkland'}} 
    end

    describe 'after INvalid search' do
      after :each do
        flash[:notice].should be
        response.should redirect_to movies_path
      end

      it 'should redirect the user to homepage when the search term is nil' do
        post :search_tmdb, {"search_form"=>{"term"=>""}}
      end
      it 'should redirect the user to homepage when the search term is blank' do
        post :search_tmdb, {"search_form"=>{"term"=>"    "}}
      end
      it 'should redirect the user to homepage when no matching found' do
        Movie.stub(:find_in_tmdb).and_return([])
        post :search_tmdb, {"search_form"=>{"term"=>'parkland'}} 
      end
    end

    describe 'after valid search' do
      before :each do
        Movie.stub(:find_in_tmdb).and_return(@fake_results)
        post :search_tmdb, {"search_form"=>{"term"=>'parkland'}} 
      end
      it 'should select the Search Results template for rendering'do
        response.should render_template('search_tmdb') 
      end
      it 'should make the TMDb search results and the serach term available to that template' do
        assigns(:movies).should == @fake_results
        assigns(:search_term).should =='parkland'
      end
    end
  end
  
  describe 'adding selected movies' do 
    it 'should call the model method that performs creation from TMdb with appropriate args' do
      Movie.should_receive(:create_from_tmdb).with([27593,14898])
      post :add_tmdb, {:tmdb_movies=>{"27593"=>"1", "14898"=>"1"}}
    end
    describe 'after submit the selected movies' do
      after :each do
        flash[:notice].should be
        response.should redirect_to movies_path
      end

      it 'should redirect the user to homepage when NOTHING select with a notice'do
        post :add_tmdb, {} 
      end  
      it 'should redirect the user to homepage with a notice after susccessful creation' do 
        Movie.stub(:create_from_tmdb).with([27593,14898]).and_return(true)
        post :add_tmdb, {:tmdb_movies=>{"27593"=>"1", "14898"=>"1"}}
      end
    end
  end
end
