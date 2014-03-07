module ApplicationHelper
  def avatar_image_url
    current_user.try(:image)
  end
end
