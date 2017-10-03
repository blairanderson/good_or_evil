namespace :seed do
  task wirecutter: :environment do
    fetched = Hash.from_xml(open("https://thewirecutter.com/post_review.xml"))
    fetched["urlset"]["url"].each_with_index do |loc, i|
      safely do
        List.transaction do
          url = loc["loc"]
          index = i + 1
          name = url.split("/").last.titleize
          # change name from best <something> to best gift <something>
          name.gsub("Best ", "Best Gift ") if (name.include?("Best ") && !name.include?("Gift "))

          list = List.bootstrap.where(name: name).first_or_create!
          updated = list.update!(sort: index, source: url)
          puts "#{index.to_s.rjust(3,"0")}[#{updated}]: #{name}"
        end
      end
    end
  end
end
