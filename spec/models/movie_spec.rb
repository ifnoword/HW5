require 'spec_helper'

describe Movie do
  describe 'searching TMDb by keyword' do
    before :each do
      @fake_keyword='parkland'
      @fake_result=[Tmdb::Movie.new(:original_title=>"Parkland",:release_date=>"2013-10-04"),Tmdb::Movie.new(:original_title=>"killer Deal",:release_date=>"1999-03-25")]
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
          movie.should include(:title, :release_date, :rating)
        end
      end

      it 'should return an empty array when NO matching found' do
        Tmdb::Movie.stub(:find).with(@fake_keyword).and_return([])
        Movie.find_in_tmdb(@fake_keyword).should == []
      end
    end
  end

end
