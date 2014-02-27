module ApplicationHelper
 def emojify(content)
    content.to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
      if Emoji.names.include?($1)
        '<img alt="' + $1 + '" height="20" src="' + asset_path("images/emoji/#{$1}.png") + '" style="vertical-align:middle" width="20" />'
      else
        match
      end
    end.html_safe if content.present?
  end

  def userlinkify(content)
    content.to_s.gsub(/(@[a-zA-Z0-9]+)/) do |match|
      # todo: probably a good idea to check that the matched user is actually a real user on github, somehow..
      "<a href='https://github.com/#{match.from(1)}' target='_blank'>#{match}</a>"
    end.html_safe
  end

  def referencify(content, issue_url)
    base = issue_url.gsub(/\/issues\/(\d+)/, "").gsub(/\/api./, "").gsub(/\/repos/, "")

    content.to_s.gsub(/([^&]#[0-9]+)/) do |issue_number|
      # todo: probably a good idea to check that the matched user is actually a real user on github, somehow..
      url = "#{base}/issues/#{issue_number.from(2)}"

      " <a href='#{url}' target='_blank'>#{issue_number}</a>"
    end.html_safe
  end
end
