namespace :seed do
  task wirecutter: :environment do
    fetched = Hash.from_xml(open("https://thewirecutter.com/post_review.xml"))
    fetched["urlset"]["url"].each_with_index do |url, index|
      safely do
        List.transaction do
          name = url["loc"].split("/").last.titleize
          list = List.bootstrap.where(name: name).first_or_create!
          list.update!(sort: index, source: url)
          puts "#{index.to_s.rjust(3,"0")}: #{name}"
        end
      end
    end
  end
end
