require 'spec_helper'

describe "reviews module" do

  before(:each) do
    login
    create(:restaurant, :id => 4)
    # Restaurant.create(name: 'Bam Bam Sushi', description: 'Test restaurant', :id => 4)
      visit '/restaurants'
      click_link('List')
  end

  it "can add a review for a pre-existing restaurant" do
    review = "I love this restaurant. It gave me food poisoning. It got real messy. But I still love it."
    fill_in 'List', with: review
    fill_in 'Name', with: 'Baris'
    select 2, from: 'Rating'
    click_button('submit')
    #use deprecated below to avoid 'Compared using equal?, which compares object identity,
       # but expected and actual are not the same object'
    expect(current_path).should == ('/restaurants/4') 
    expect(page).to have_content(review)
  end

  it "should throw an error if form is not valid" do
    click_button('submit')

    expect(page).to have_content('error')
  end



end
