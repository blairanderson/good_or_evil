class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do
    session[:cart] ||= Hash.new(0)
  end

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def record_not_found
    flash[:alert] = "Could not find that page!"
    redirect_to root_path and return
  end

  def is_admin?
    current_user && current_user.admin?
  end

  helper_method :is_admin?

  def is_robot?
    current_user && current_user.robot?
  end

  helper_method :is_robot?

  def current_cart
    @current_cart ||= Hash.new(0).merge(
      Hash(session[:cart]).delete_if { |k, v| k.blank? || v.blank? }
    )
  end

  helper_method :current_cart

  def cart_items_count
    @cart_items_count ||= current_cart.values.map(&:to_i).sum
  end
  helper_method :cart_items_count

  def can_checkout_on_amazon?
    cart_items_count > 0
  end

  helper_method :can_checkout_on_amazon?

  def in_cart?(asin)
    asin && current_cart[asin].to_i > 0
  end

  helper_method :in_cart?

  def checkout_on_amazon
    parms = {"AssociateTag" => ENV.fetch("AWS_AFFILIATES_ASSOCIATE_TAG")}
    current_cart.to_a.each_with_index do |item, index|
      i = index+1
      parms["ASIN.#{i}"] = item[0]
      parms["Quantity.#{i}"] = item[1]
    end

    "https://www.amazon.com/gp/aws/cart/add.html?#{parms.to_query}"
  end

  helper_method :checkout_on_amazon

  def current_history
    @current_history ||= begin
      list_scope = List.visible.for_sidebar.where(id: Array(session[:historical_list_ids]))
      list_scope = list_scope.where.not(id: @list.id) if @list
      list_scope.limit(10).map do |list|
        OpenStruct.new(
          name: "#{list.name.gsub("Best ", "").gsub("Gift ", "").pluralize(list.item_count).html_safe} - #{list.item_count} #{'item'.pluralize(list.item_count)}",
          path: list_path(list)
        )
      end
    end
  end

  helper_method :current_history

  def sidebar_items
    @sidebar_items ||= begin
      list_scope = List.visible.for_sidebar
      list_scope = list_scope.where.not(id: @list.id) if @list
      lists = list_scope.limit(25).map do |list|
        OpenStruct.new(
          name: "#{list.name.html_safe} - #{list.item_count} #{'item'.pluralize(list.item_count)}",
          path: list_path(list)
        )
      end
      brands = Brand.top_list.map do |brand|
        OpenStruct.new(
          name: "#{brand.name} - #{brand.items_count} items",
          path: brand_path(brand)
        )
      end
      [lists, brands].flatten
    end
  end

  helper_method :sidebar_items
end
