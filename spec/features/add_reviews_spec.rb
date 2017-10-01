require 'spec_helper'

describe "reviews module" do

  before(:each) do
    Restaurant.create(name: 'T1', description: 'Test restaurant', :id => 4)
  end

  it "can add a review for a pre-existing restaurant" do
    visit '/restaurants'
    click_link('Add review')
    fill_in 'List', with: 'here is a test review'
    click_button('submit')
    #use deprecated below to avoid 'Compared using equal?, which compares object identity,
       # but expected and actual are not the same object'
    expect(current_path).should == ('/restaurants/4') 
    expect(page).to have_content('here is a test review')
  end

end
