class SeedList
  def self.process(list: nil, amazon_links: [], sync: true)
    amazon_links.each do |url|
      safely do
        Item.transaction do
          item = Item.where_url(url).first_or_create! do |i|
            i.sync! if sync
          end
          list.list_items.where(item_id: item.id).first_or_create!
        end
      end
    end
  end

  def self.from_wirecutter_loc(loc, index)
    before = Item.count

    user_agent_alias = Mechanize::AGENT_ALIASES.keys.sample
    agent = Mechanize.new do |a|
      a.user_agent_alias = user_agent_alias
      a.follow_meta_refresh = true
      a.redirect_ok = true
    end
    wcagent = Mechanize.new do |a|
      a.user_agent_alias = user_agent_alias
      a.follow_meta_refresh = false
      a.redirect_ok = false
    end

    url = loc.dig("loc")
    agent.get(url)
    amazon_links = agent.page.search("a[data-store='Amazon']").map do |link|
      {
        text: link.text.strip,
        href: link.attr("href")
      }
    end

    # return only items with dollar signs(amazon has offer)
    amazon_links = amazon_links.select { |link| link[:text].include?("$") }
    # return only the wirecutter URL
    amazon_links = amazon_links.map { |link| link[:href] }
    amazon_links = amazon_links.uniq

    # convert wirecutter URL to Amazon URL
    amazon_links = amazon_links.map do |link|
      wcagent.get(link)
      wcagent.page.meta_refresh.first.uri.to_s
    end

    amazon_links = amazon_links.uniq
    amazon_links = amazon_links.select { |link| link.downcase.include?("amazon.com/") }

    if url.blank? || amazon_links.empty?
      puts "EMPTY: #{url}"
      return false
    end

    name = url.split("/").last.titleize
    name = name.gsub("Best ", "Best Gift ") if (name.include?("Best ") && !name.include?("Gift "))
    list = List.bootstrap.where(source: url).first_or_create!(name: name)
    list.update!(sort: index, name: name)
    SeedList.process(list: list, amazon_links: amazon_links, sync: false)

    puts "[new:#{Item.count - before}][total:#{list.items.count}]: #{name}"
  end
end
