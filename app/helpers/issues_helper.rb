module IssuesHelper
  def pull_request_url(issue)
    pr = issue.try(:pull_request)

    if pr.rels[:html]
      return pr.rels[:html].href
    else
      nil
    end
  end

  def pull_request_changes_url(pr_url)
    return "#{pr_url}/files"
  end

  def render_issue_body(body, issue_url)
    BlueCloth.new(
      emojify(
        userlinkify(
          referencify(
            body, issue_url
          )
        )
      )
    ).to_html
  end
end
