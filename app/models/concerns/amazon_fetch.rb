# AmazonFetch.item_lookup(asin: asin, amazon_only: true)
class AmazonFetch

  def self.fetch(asin)
    resp = item_lookup(asin: asin)
    resp ? parse_response(resp) : {error: "Not Found"}
  end

  def self.parse_response(item)
    data = {}
    # FLAT DATA
    data["asin"] = item.get("ASIN")
    data["title"] = item.get("ItemAttributes/Title")
    data["brand"] = item.get("ItemAttributes/Brand")
    data["description"] = item.get_hash("EditorialReviews/EditorialReview").try { |editorial| editorial.dig("Content") }
    data["parent_asin"] = item.get("ParentASIN")
    data["buy_now"] = CGI.unescapeHTML(item.get("DetailPageURL"))
    data["total_offers"] = item.get("OfferSummary/TotalNew").to_i
    data["sales_rank"] = item.get("SalesRank").to_i

    data["dimensions"] = item.get_hash("ItemAttributes/ItemDimensions")
    data["package_dimensions"] = item.get_hash("ItemAttributes/PackageDimensions")
    data["buy_box"] = {
      "winning" => item.get_hash("OfferSummary/LowestNewPrice"),
      "offer" => item.get_hash("Offers/Offer/OfferListing/Price")
    }
    images = item.get_element("ImageSets/ImageSet")
    data["images"] = images ? images.get_hash.keys.each_with_object({}) do |name, image_sets|
      image_sets[name] = item.get_hash("ImageSets/ImageSet/#{name}")
    end : []

    data.delete_if { |_, value| value.nil? }.with_indifferent_access
  end

  def self.item_lookup(asin: nil, amazon_only: true)
    lookup_options = {
      response_group: "OfferFull,Offers,Medium,Images",
      condition: "New"
    }
    lookup_options.merge!({merchant_id: "Amazon"}) if amazon_only
    Amazon::Ecs.item_lookup(asin, lookup_options).try { |resp| resp.items.first }
  end

end
