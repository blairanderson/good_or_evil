namespace :seed do
  task fetch: :environment do
    fetched = Hash.from_xml(open("https://thewirecutter.com/post_review.xml"))
    fetched["urlset"]["url"].each_with_index do |loc, index|
      List.transaction do
        url = loc["loc"]
        list = List.bootstrap.where(name: url.split("/").last.titleize).first_or_create!
        list.update!(sort: 1, source: url)
      end
    end
  end
end
