namespace :seed do
  require 'benchmark'
  task wirecutter: :environment do
    Hash.from_xml(open("https://thewirecutter.com/post_review.xml")).dig('urlset', 'url').shuffle.each_with_index do |loc, i|
      ms = Benchmark.ms do
        SeedList.from_wirecutter_loc(loc, i + 1)
      end

      puts (ms/1000).round(2)
    end
  end
end
