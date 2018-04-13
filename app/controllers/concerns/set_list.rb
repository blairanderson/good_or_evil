module SetList
  def current_list
    @list ||= current_user.lists.friendly.find(params[:list_id] || params[:id])
  end
end
