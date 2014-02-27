module ApplicationHelper
 def emojify(content)
    h(content).to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
      if Emoji.names.include?($1)
        '<img alt="' + $1 + '" height="20" src="' + asset_path("images/emoji/#{$1}.png") + '" style="vertical-align:middle" width="20" />'
      else
        match
      end
    end.html_safe if content.present?
  end

  def userlinkify(content)
    h(content).to_s.gsub(/(@[a-zA-Z0-9]+\w)/) do |match|
      # todo: probably a good idea to check that the matched user is actually a real user on github, somehow..
      "<a href='https://github.com/#{match.from(1)}' target='_blank'>#{match}</a>"
    end.html_safe
  end
end
