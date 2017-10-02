class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action do
    session[:cart] ||= Hash.new(0)
  end
  helper_method :current_cart, :can_checkout_on_amazon?, :in_cart?, :checkout_on_amazon

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def record_not_found
    flash[:alert] = "Could not find that page!"
    redirect_to root_path and return
  end

  def current_cart
    @current_cart ||= Hash.new(0).merge(
      Hash(session[:cart]).delete_if { |k, v| k.blank? || v.blank? }
    )
  end

  def can_checkout_on_amazon?
    current_cart.values.map(&:to_i).sum > 0
  end

  def in_cart?(asin)
    asin && current_cart[asin].to_i > 0
  end

  def checkout_on_amazon
    parms = {"AssociateTag" => ENV.fetch("AWS_AFFILIATES_ASSOCIATE_TAG")}
    current_cart.to_a.each_with_index do |item, index|
      i = index+1
      parms["ASIN.#{i}"] = item[0]
      parms["Quantity.#{i}"] = item[1]
    end

    "https://www.amazon.com/gp/aws/cart/add.html?#{parms.to_query}"
  end
end
