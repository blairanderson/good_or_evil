require 'json'

desc 'backup'
task backup: :environment do
  return unless Rails.env.development?
  items = Item.select(:name, :description, :price_cents, :brand_id, :buy_now).as_json.map{|a| a.except("id") }

  File.open("db/seeds/items.json","w") do |f|
    f.write(JSON.pretty_generate(items))
    puts 'completed'
  end
end
