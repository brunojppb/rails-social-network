module ApplicationHelper

  def full_title(page_title = '')
    base_title = 'Social Net'
    if page_title.empty?
      base_title
    else
      "#{page_title} | Social Net"
    end
  end

end
