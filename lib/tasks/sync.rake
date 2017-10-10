namespace :sync do
  task brand_items_count: :environment do
    Brand.pluck(:id).each do |b_id|
      Brand.reset_counters(b_id, :items)
    end
  end
end
