class SitesController < PublicController
  layout "site"
  def index
    @lists = current_account.lists.published.paginate(per_page: current_account.lists_per_page, page: params[:page])
  end

  def show
    @list = current_account.lists.published.find(params[:id])
  end
end
