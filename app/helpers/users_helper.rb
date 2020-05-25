module UsersHelper
  def gravatar_for(user, size: 80)
    if user.email.nil?
      image_tag("/default.jpg", :size => 50, alt: user.name, class: "gravatar")
    else
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
  end
end
