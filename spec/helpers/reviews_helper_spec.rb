require 'spec_helper'

describe ListsHelper do
  let(:review) { List.new }

  describe '.review_color' do

    context 'if review < 3 stars' do
      it 'should return alert-danger' do
        review.ratings = 2
        expect(helper.review_color(review)).to eq 'alert-danger'
      end
    end

    context 'if review < 5 stars' do
      it 'should return alert-warning' do
        review.ratings = 4
        expect(helper.review_color(review)).to eq 'alert-warning'
      end
    end

    context 'if review is 5 stars' do
      it 'should return alert-success' do
        review.ratings = 5
        expect(helper.review_color(review)).to eq( 'alert-success')
      end
    end
  
  end


  describe '.star_rating' do

    context '5 stars' do
      it 'should show 5 filled in stars' do
        review.ratings = 5
        expect(helper.star_rating(review)).to eq( '★★★★★')
      end
    end

    context '3 stars' do
      it 'should show 3 filled in stars and 2 empty stars' do
        review.ratings = 3
        expect(helper.star_rating(review)).to eq( '★★★☆☆')
      end
    end

    context 'Unrated' do
      it 'keeps unrated as the rating' do
        review.ratings = 'Unrated'
        expect(helper.star_rating(Restaurant.new)).to eq( 'Unrated')
      end
    end

  end
end
