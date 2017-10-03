namespace :seed do
  task fetch: :environment do
    fetched = Hash.from_xml(open("https://thewirecutter.com/post_review.xml"))
    fetched["urlset"]["url"].each_with_index do |url, index|
      List.transaction do
        list = List.bootstrap.where(name: url["loc"].split("/").last.titleize).first_or_create!
        list.update!(sort: index, source: url)
      end
    end
  end
end
