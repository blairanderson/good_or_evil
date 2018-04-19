class SitesController < PublicController
  layout "site"

  def index
    lists = current_account.lists.published
    @query = params[:q].to_s.strip
    if @query.length > 0
      lists = lists.search_for(@query)
    end
    @lists = lists.paginate(per_page: current_account.lists_per_page, page: params[:page])
    current_account.update_column(:page_views, current_account.page_views+1)
  end

  def current_list
    @list ||= current_account.lists.published.friendly.find(params[:id])
  end

  helper_method :current_list

  def show
    session[:historical_list_ids] = (Array(session[:historical_list_ids]).unshift(current_list.id)).flatten.uniq.slice(0, 10)
    current_list.update_column(:page_views, current_list.page_views+1)
  end
end
