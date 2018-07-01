class SitesController < PublicController
  layout "site"

  def index
    query = params[:q].to_s.strip
    if query.length > 0
      redirect_to(site_search_path(q: query)) and return
    end
    current_account.update_column(:page_views, current_account.page_views+1)
    @lists = current_account.lists.visible.sorted.paginate(per_page: current_account.lists_per_page, page: params[:page])
  end

  def search
    query = params[:q].to_s.strip
    if query.length < 2
      redirect_to(site_path) and return
    end

    current_account.update_column(:page_views, current_account.page_views+1)
    @lists = current_account.lists.visible.search_for(query).paginate(per_page: current_account.lists_per_page, page: params[:page])
  end

  def current_list
    @list ||= current_account.lists.published.friendly.find(params[:id])
  end

  def current_list_items
    @current_list_items ||= current_list.list_items.sorted
  end

  helper_method :current_list, :current_list_items

  def show
    session[:historical_list_ids] = (Array(session[:historical_list_ids]).unshift(current_list.id)).flatten.uniq.slice(0, 10)
    current_list.update_column(:page_views, current_list.page_views+1)
  end
end
