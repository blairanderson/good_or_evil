namespace :items do
  task sync: :environment do
    Item.sync!(limit: 20)
  end
end
