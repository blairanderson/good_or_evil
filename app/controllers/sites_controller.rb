class SitesController < PublicController
  layout "site"

  def index
    @lists = current_account.lists.published.paginate(per_page: current_account.lists_per_page, page: params[:page])
    current_account.update_column(:page_views, current_account.page_views+1)
  end

  def show
    @list = current_account.lists.published.friendly.find(params[:id])
    session[:historical_list_ids] = (Array(session[:historical_list_ids]).unshift(@list.id)).flatten.uniq.slice(0, 10)
    @list.update_column(:page_views, @list.page_views+1)
  end
end
