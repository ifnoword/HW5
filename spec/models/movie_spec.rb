require 'spec_helper'

describe Movie do
  #test search_tmdb
  describe 'searching TMDb by keyword' do
    before :each do
      @fake_keyword='parkland'
      @fake_result=[Tmdb::Movie.new(:original_title=>"Parkland",:release_date=>"2013-10-04", :id=>'123'),Tmdb::Movie.new(:original_title=>"killer Deal",:release_date=>"1999-03-25", :id=>'456')]
    end
    it 'should call TMDb with keyword' do
      Tmdb::Api.should_receive(:key)
      Tmdb::Movie.should_receive(:find).with(@fake_keyword).and_return(@fake_result)
      Movie.find_in_tmdb(@fake_keyword)
    end
    
    describe 'after search in TMDb' do
      before :each do
        Tmdb::Api.stub(:key)
      end
      it 'should return an array of hashes when matching FOUND' do
        Tmdb::Movie.stub(:find).with(@fake_keyword).and_return(@fake_result)
        return_value = Movie.find_in_tmdb(@fake_keyword)
        return_value.class.should == Array
        return_value.size.should > 0
        return_value.each do |movie|
          movie.class.should == Hash
          movie.should include(:title, :release_date, :rating, :tmdb_id)
        end
      end
      it 'should return an empty array when NO matching found' do
        Tmdb::Movie.stub(:find).with(@fake_keyword).and_return([])
        Movie.find_in_tmdb(@fake_keyword).should == []
      end
    end
  end
  #test add_tmdb
  describe 'Creating movies from TMDb' do 
    before :each do
      @fake_tmdb_movie=Tmdb::Movie.new(:original_title=>"Parkland",:release_date=>"2013-10-04", :id=>123)
    end
    it 'should call TMDb to get details of movies by their tmdb_ids' do
      Tmdb::Movie.should_receive(:detail).with(123).and_return(@fake_tmdb_movie)
      Movie.create_from_tmdb([123])
    end
    it 'should call Movie::create to add new movies by a hash' do
      Tmdb::Movie.stub(:detail).with(123).and_return(@fake_tmdb_movie)
      Movie.should_receive(:create).with(an_instance_of(Hash)).and_return(true)
      Movie.create_from_tmdb([123])
    end
    it 'should return false after creation failure' do
      Tmdb::Movie.stub(:detail).with(123).and_return(@fake_tmdb_movie)
      Movie.stub(:create).and_return(false)
      Movie.create_from_tmdb([123]).should be_false
    end
  end
end
