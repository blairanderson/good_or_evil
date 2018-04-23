module SetList
  def current_list
    @list ||= current_account.lists.friendly.find(params[:list_id] || params[:id])
  end
end
