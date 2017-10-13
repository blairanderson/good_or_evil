module SetList
  def can_bootstrap?
    is_admin? || is_robot?
  end

  def current_list
    @list ||= (can_bootstrap? ? List : current_user.lists).find(params[:list_id] || params[:id])
  end
end
