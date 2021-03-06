namespace :seed do
  task wirecutter: :environment do
    require 'benchmark'
    Hash.from_xml(open("https://thewirecutter.com/post_review.xml")).dig('urlset', 'url').each_with_index do |loc, i|
      ms = Benchmark.ms do
        SeedList.from_wirecutter_loc(loc, i + 1)
      end

      puts (ms/1000).round(2)
    end
  end
end
