require 'spec_helper'

describe "editing reviews" do

  before(:each) do
    user = login
    # create(:restaurant, :id => 5)
    restaurant = Restaurant.create(name: 'Bam Bam Sushi', description: 'Test restaurant. This restaurant is not real', :id => 3)
    restaurant.reviews << List.create(name: "Wilbur", body: "The worst sushi in town. The sushi is awful. I hate this sushi is the wost thing ever", ratings: 2, user: user)
    visit '/restaurants/3'
  end

  it "should be able to delete reviews" do
    click_link('Delete')
    expect(page).not_to have_content('I love it')
  end

  it "should be able to edit reviews" do
    click_link('Edit')
    fill_in('Name', with: 'Wilbur')
    fill_in('List', with: "The second best sushi in town. The sushi her is amazing. I love this sushi is the best thing ever")
    select 3, from: 'Rating'
    click_button('Update')
    expect(page).to have_content('The second best sushi in town')
  end
end
