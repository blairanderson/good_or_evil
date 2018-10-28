class Source < ActiveRecord::Base
  has_many :articles

  def fetch!
    url = "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
    xml = open(url).read
    Feedjira::Parser::RSS.parse(xml).entries.each do |datum|
      article = self.articles.where(url: datum.entry_id).first_or_create!
      article.update!({
          title: datum.title,
          author: datum.author,
          categories: Array.wrap(datum.categories),
          image: datum.image,
          published_at: datum.published,
          summary: datum.summary
        })

      #   @title="Used to Hearing ‘Shabbat Shalom,’ a Historic Jewish Enclave Rings Out With Gunshots",
      #   @entry_id="https://www.nytimes.com/2018/10/27/us/pittsburgh-shooting-squirrel-hill-tree-of-life.html",
      #   @author="CAMPBELL ROBERTSON",
      #   @image="https://static01.nyt.com/images/2018/10/28/us/28xp-scene-sub1/28xp-scene-sub1-moth.jpg",
      #   @categories=["Jews and Judaism", "Synagogues", "Pittsburgh (Pa)"],
      #   @published=2018-10-28 03:01:17 UTC,
      #   @summary="Pittsburgh’s Squirrel Hill neighborhood is a close-knit Jewish community. Its day of worship turned into one of mourning after a gunman stormed into a synagogue.",

      #   @url="https://www.nytimes.com/2018/10/27/us/pittsburgh-shooting-squirrel-hill-tree-of-life.html?partner=rss&emc=rss">,

    end
  end
end



