namespace :items do
  task sync: :environment do
    Item.sync!(limit: 50)
  end
end
